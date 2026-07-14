# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::LibcalEvents, type: :service do
  let(:remote_source) { "https://charlesstudy.temple.edu/1.1/events?cal_id=6197" }
  let(:response_body) { [{ "id" => 123, "title" => "Test Event" }].to_json }
  # OpenURI decorates the response IO with a #status method (via OpenURI::Meta);
  # StringIO doesn't have one, so add it to a real IO rather than stubbing StringIO.
  let(:unauthorized_io) do
    StringIO.new("Unauthorized").tap do |io|
      io.define_singleton_method(:status) { ["401", "Unauthorized"] }
    end
  end
  let(:unauthorized_error) { OpenURI::HTTPError.new("401 Unauthorized", unauthorized_io) }

  around do |example|
    original_client_id = Rails.configuration.libcal_client_id
    original_client_secret = Rails.configuration.libcal_client_secret
    original_token_url = Rails.configuration.libcal_token_url

    Rails.configuration.libcal_client_id = nil
    Rails.configuration.libcal_client_secret = nil
    Rails.configuration.libcal_token_url = "https://charlesstudy.temple.edu/1.1/oauth/token"

    example.run
  ensure
    Rails.configuration.libcal_client_id = original_client_id
    Rails.configuration.libcal_client_secret = original_client_secret
    Rails.configuration.libcal_token_url = original_token_url
  end

  describe "event images" do
    let(:image_url) { "https://example.com/event.png" }
    let(:image_body) { [{ "id" => 555, "title" => "Image Event", "featured_image" => image_url }].to_json }
    # A one-pixel PNG, so ActiveStorage has real image bytes to analyze.
    let(:png) { Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==") }

    before do
      # The IPv4 adapter resolves the host itself, and WebMock does not intercept DNS.
      allow(Addrinfo).to receive(:getaddrinfo)
        .with("example.com", nil, Socket::AF_INET, :STREAM)
        .and_return([Addrinfo.tcp("93.184.216.34", 443)])
    end

    it "downloads the image over IPv4 and attaches it" do
      stub_request(:get, image_url).to_return(status: 200, body: png, headers: { "Content-Type" => "image/png" })

      described_class.call(response_body: image_body)

      event = Event.find_by(guid: "555")
      expect(event.image).to be_attached
    end

    it "saves the event without the image when the download fails" do
      stub_request(:get, image_url).to_return(status: 404)

      expect { described_class.call(response_body: image_body) }.to change(Event, :count).by(1)

      event = Event.find_by(guid: "555")
      expect(event).to be_present
      expect(event.image).not_to be_attached
    end

    it "saves the event without the image instead of dropping the whole record when oversized" do
      oversized = "x" * (I18n.t("manifold.default.image_file_size_limit").kilobyte + 1)
      stub_request(:get, image_url).to_return(status: 200, body: oversized, headers: { "Content-Type" => "image/png" })

      expect { described_class.call(response_body: image_body) }.to change(Event, :count).by(1)

      event = Event.find_by(guid: "555")
      expect(event).to be_present
      expect(event.image).not_to be_attached
    end

    it "caches the failed event titles for the admin flash" do
      stub_request(:get, image_url).to_return(status: 404)

      expect(Rails.cache).to receive(:write).with(
        "events_image_error", ["Image Event"], hash_including(:expires_in)
      )

      described_class.call(response_body: image_body)
    end
  end

  describe "remote request date window" do
    it "spans the lookback start through the lookahead and is clamped to 365 days" do
      service = described_class.new(response_body: "[]")
      params = service.send(:source_query_params, 6197).to_h

      start_date = Date.iso8601(params["date"])
      window_end = start_date + params["days"]

      expect(params["days"]).to be <= 365
      expect(start_date).to be < Date.current              # looks into the past
      expect(window_end).to be > (Date.current + 30)        # ...and into the future
    end
  end

  describe "location crosswalk" do
    it "assigns a managed building (plus space/address) from the location name" do
      building = FactoryBot.create(:building, name: "Ginsburg Health Sciences Library")
      body = [{ "id" => 5001, "title" => "Crosswalk Event", "location" => "Ginsburg Library Room 160" }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "5001")

      expect(event.building).to eq(building)
      expect(event[:location_space]).to eq("Room 160")
      expect(event[:address]).to eq("1900 N. 13th Street")
    end

    it "keeps external location details when no managed building matches" do
      body = [{ "id" => 5002, "title" => "External Event", "location" => "Temple Performing Arts Center" }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "5002")

      expect(event.building).to be_nil
      expect(event[:location_name]).to eq("Temple Performing Arts Center")
    end
  end

  describe "clearing a removed location" do
    it "clears the stale building and location fields when a location is removed" do
      building = FactoryBot.create(:building, name: "Ginsburg Health Sciences Library")
      described_class.call(response_body: [{ "id" => 9100, "title" => "Moved Online", "location" => "Ginsburg Library Room 160" }].to_json)

      event = Event.find_by(guid: "9100")
      expect(event.building).to eq(building)

      # Re-sync the same event now online with no location (LibCal sends an empty name).
      described_class.call(response_body: [{ "id" => 9100, "title" => "Moved Online",
                                             "location" => { "id" => 0, "type" => 0, "name" => "" } }].to_json)
      event.reload

      expect(event.building_id).to be_nil
      expect(event[:location_name]).to be_nil
      expect(event[:location_space]).to be_nil
      expect(event[:address]).to be_nil
    end
  end

  describe "online events" do
    it "captures the LibCal online_join_url into event_url and tags the type Online" do
      body = [{ "id" => 9200, "title" => "Webinar",
                "online_join_url" => "https://temple.zoom.us/j/96251802072",
                "location" => { "id" => 0, "type" => 0, "name" => "" } }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "9200")

      expect(event.event_url).to eq("https://temple.zoom.us/j/96251802072")
      expect(event.event_type).to include("Online")
    end
  end

  describe "overwrite-by-guid" do
    it "updates the existing record instead of skipping or duplicating it" do
      described_class.call(response_body: [{ "id" => 7001, "title" => "First" }].to_json)
      described_class.call(response_body: [{ "id" => 7001, "title" => "Second" }].to_json)

      expect(Event.where(guid: "7001").count).to eq(1)
      expect(Event.find_by(guid: "7001").title).to eq("Second")
    end
  end

  describe "libcal categories mapping" do
    it "stores categories in the libcal_categories column and leaves tags nil" do
      body = [{ "id" => 8001, "title" => "Categorized Event",
                "category" => [{ "id" => 1, "name" => "Workshop" }, { "id" => 2, "name" => "AI" }] }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "8001")

      expect(event.libcal_categories).to eq("Workshop, AI")
      expect(event[:tags]).to be_nil
    end
  end

  describe "access token handling" do
    it "does not fetch a token when using a provided response body" do
      service = described_class.new(response_body:)

      expect(service).not_to receive(:fetch_access_token)
      expect(service.read_events.first["id"]).to eq(123)
    end

    it "raises when remote sync needs a token and oauth credentials are missing" do
      service = described_class.new(events_url: remote_source)

      expect { service.read_events }
        .to raise_error(
          described_class::MissingAccessTokenConfigurationException,
          /LibCal token URL, client ID, and client secret must be configured/
        )
    end

    it "fetches a fresh token and retries once after a 401 response" do
      service = described_class.new(events_url: remote_source, access_token: "expired-token")

      expect(service).to receive(:fetch_access_token).once.and_return("fresh-token")
      expect(URI).to receive(:open).with(
        remote_source,
        hash_including("Authorization" => "Bearer expired-token")
      ).ordered.and_raise(unauthorized_error)
      expect(URI).to receive(:open).with(
        remote_source,
        hash_including("Authorization" => "Bearer fresh-token")
      ).ordered.and_return(StringIO.new(response_body))

      expect(service.read_events.first["id"]).to eq(123)
    end
  end
end
