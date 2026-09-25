# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::LibcalEvents, type: :service do
  define_negated_matcher :not_change, :change
  define_negated_matcher :a_string_excluding, :a_string_including

  let(:remote_source) { "https://charlesstudy.temple.edu/1.1/events?cal_id=6197" }
  let(:response_body) { [{ "id" => 123, "title" => "Test Event" }].to_json }
  let(:unauthorized_io) do
    StringIO.new("Unauthorized").tap do |io|
      io.define_singleton_method(:status) { ["401", "Unauthorized"] }
    end
  end
  let(:unauthorized_error) { OpenURI::HTTPError.new("401 Unauthorized", unauthorized_io) }

  def stub_libcal_config(**settings)
    allow(Rails.configuration).to receive_messages(**settings)
  end

  before do
    stub_libcal_config(
      libcal_client_id: nil,
      libcal_client_secret: nil,
      libcal_token_url: "https://charlesstudy.temple.edu/1.1/oauth/token"
    )
    # The test env uses a null store; image-failure reporting needs a real cache to observe.
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end

  describe "event images" do
    let(:image_url) { "https://example.com/event.png" }
    let(:image_body) { [{ "id" => 555, "title" => "Image Event", "featured_image" => image_url }].to_json }
    let(:png) { Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==") }

    before do
      allow(Addrinfo).to receive(:getaddrinfo)
        .with("example.com", nil, Socket::AF_INET, :STREAM)
        .and_return([Addrinfo.tcp("93.184.216.34", 443)])
    end

    it "downloads the image over IPv4 and attaches it" do
      stub_request(:get, image_url).to_return(status: 200, body: png, headers: { "Content-Type" => "image/png" })
      expect(PreprocessEventImageVariantsJob).to receive(:perform_now).with(instance_of(Event))

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

    it "processes derivatives for the retained image when the download fails" do
      existing = FactoryBot.create(:event, :with_image, guid: "555")
      stub_request(:get, image_url).to_return(status: 404)

      expect(PreprocessEventImageVariantsJob).to receive(:perform_now).with(instance_of(Event))

      described_class.call(response_body: image_body)

      expect(existing.reload.image).to be_attached
    end

    it "keeps the existing blob when the downloaded image is unchanged" do
      existing = FactoryBot.create(:event, guid: "555")
      existing.image.attach(io: StringIO.new(png), filename: "event.png", content_type: "image/png")
      original_blob_id = existing.image.blob.id
      stub_request(:get, image_url).to_return(status: 200, body: png, headers: { "Content-Type" => "image/png" })

      described_class.call(response_body: image_body)

      expect(existing.reload.image.blob.id).to eq(original_blob_id)
    end

    it "still processes derivatives when the downloaded image is unchanged" do
      existing = FactoryBot.create(:event, guid: "555")
      existing.image.attach(io: StringIO.new(png), filename: "event.png", content_type: "image/png")
      stub_request(:get, image_url).to_return(status: 200, body: png, headers: { "Content-Type" => "image/png" })

      expect(PreprocessEventImageVariantsJob).to receive(:perform_now).with(instance_of(Event))

      described_class.call(response_body: image_body)
    end

    it "replaces the blob when the downloaded image differs" do
      existing = FactoryBot.create(:event, :with_image, guid: "555")
      original_blob_id = existing.image.blob.id
      stub_request(:get, image_url).to_return(status: 200, body: png, headers: { "Content-Type" => "image/png" })

      described_class.call(response_body: image_body)

      expect(existing.reload.image.blob.id).not_to eq(original_blob_id)
    end

    it "purges the image and clears alt text when LibCal drops featured_image" do
      existing = FactoryBot.create(:event, :with_image, guid: "555")
      imageless_body = [{ "id" => 555, "title" => "Image Event" }].to_json

      described_class.call(response_body: imageless_body)

      expect(existing.reload.image).not_to be_attached
      expect(existing.alt_text).to be_nil
    end

    it "defers the blob deletion to the queue instead of purging inline" do
      existing = FactoryBot.create(:event, :with_image, guid: "555")
      blob_id = existing.image.blob.id
      imageless_body = [{ "id" => 555, "title" => "Image Event" }].to_json

      described_class.call(response_body: imageless_body)

      expect(existing.reload.image).not_to be_attached
      expect(ActiveStorage::Blob.exists?(blob_id)).to be(true)
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

    describe "Honeybadger reporting" do
      before { allow(Honeybadger).to receive(:notify) }

      it "logs and reports a failed download with the event and image url" do
        log = stub_logger
        stub_request(:get, image_url).to_return(status: 404)

        described_class.call(response_body: image_body)

        expect(log).to have_received(:info).with("LibCal image retrieval failure: Image request for #{image_url} returned 404")
        expect(Honeybadger).to have_received(:notify).with(
          an_instance_of(described_class::ImageDownloadException).and(having_attributes(message: /returned 404/)),
          context: { libcal_event_id: "555", libcal_event_title: "Image Event", image_url: }
        )
      end

      it "reports an oversized image" do
        oversized = "x" * (I18n.t("manifold.default.image_file_size_limit").kilobyte + 1)
        stub_request(:get, image_url).to_return(status: 200, body: oversized, headers: { "Content-Type" => "image/png" })

        described_class.call(response_body: image_body)

        expect(Honeybadger).to have_received(:notify).with(
          an_instance_of(described_class::ImageDownloadException).and(having_attributes(message: /over the \d+-byte limit/)),
          context: hash_including(libcal_event_id: "555")
        )
      end

      it "filters a credential in the image url from the report" do
        signed_url = "https://example.com/event.png?cal_id=1&token=secret"
        stub_request(:get, signed_url).to_return(status: 404)

        described_class.call(response_body: [{ "id" => 555, "title" => "Image Event", "featured_image" => signed_url }].to_json)

        expect(Honeybadger).to have_received(:notify).with(
          having_attributes(message: a_string_excluding("secret")),
          context: hash_including(image_url: "https://example.com/event.png?cal_id=1&token=[FILTERED]")
        )
      end
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
      body = [{ "id" => 5001, "title" => "Crosswalk Event", "location" => { "id" => 12, "type" => 1, "name" => "Ginsburg Library Room 160" } }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "5001")

      expect(event.building).to eq(building)
      expect(event[:location_space]).to eq("Room 160")
      expect(event[:address]).to eq("1900 N. 13th Street")
    end

    it "keeps external location details when no managed building matches" do
      body = [{ "id" => 5002, "title" => "External Event", "location" => { "id" => 0, "type" => 0, "name" => "Temple Performing Arts Center" } }].to_json

      described_class.call(response_body: body)
      event = Event.find_by(guid: "5002")

      expect(event.building).to be_nil
      expect(event[:location_name]).to eq("Temple Performing Arts Center")
    end
  end

  describe "clearing a removed field" do
    it "clears a stored value when LibCal stops sending it" do
      registered = [{ "id" => 9200, "title" => "Workshop", "registration" => true,
                      "url" => { "public" => "https://libcal.example.com/event/9200" } }].to_json
      described_class.call(response_body: registered)

      event = Event.find_by(guid: "9200")
      expect(event.registration_link).to eq("https://libcal.example.com/event/9200")

      unregistered = [{ "id" => 9200, "title" => "Workshop", "registration" => false,
                        "url" => { "public" => "https://libcal.example.com/event/9200" } }].to_json
      described_class.call(response_body: unregistered)

      expect(event.reload.registration_link).to be_nil
    end
  end

  describe "clearing a removed location" do
    it "clears the stale building and location fields when a location is removed" do
      building = FactoryBot.create(:building, name: "Ginsburg Health Sciences Library")
      described_class.call(response_body: [{ "id" => 9100, "title" => "Moved Online", "location" => { "id" => 12, "type" => 1, "name" => "Ginsburg Library Room 160" } }].to_json)

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

    context "when oauth credentials are configured" do
      let(:token_url) { Rails.configuration.libcal_token_url }

      before do
        stub_libcal_config(libcal_client_id: "client-id", libcal_client_secret: "client-secret")
      end

      it "fetches a token with client credentials and sends it as a bearer token" do
        token_request = stub_request(:post, token_url)
          .with(basic_auth: ["client-id", "client-secret"], body: { "grant_type" => "client_credentials" })
          .to_return(status: 200, body: { access_token: "issued-token" }.to_json)
        events_request = stub_request(:get, remote_source)
          .with(headers: { "Authorization" => "Bearer issued-token" })
          .to_return(status: 200, body: response_body)

        events = described_class.new(events_url: remote_source).read_events

        expect(events.map { |event| event["id"] }).to eq([123])
        expect(token_request).to have_been_requested.once
        expect(events_request).to have_been_requested.once
      end

      it "raises when the token endpoint rejects the credentials" do
        stub_request(:post, token_url).to_return(status: 401, body: { error: "invalid_client" }.to_json)

        expect { described_class.new(events_url: remote_source).read_events }
          .to raise_error(described_class::MissingAccessTokenConfigurationException, /Unable to fetch LibCal access token: 401/)
      end

      it "raises when the token endpoint succeeds without an access token" do
        stub_request(:post, token_url).to_return(status: 200, body: {}.to_json)

        expect { described_class.new(events_url: remote_source).read_events }
          .to raise_error(described_class::MissingAccessTokenConfigurationException, /Unable to fetch LibCal access token: 200/)
      end

      it "gives up after a single retry when LibCal keeps answering 401" do
        token_request = stub_request(:post, token_url)
          .to_return(status: 200, body: { access_token: "fresh-token" }.to_json)
        events_request = stub_request(:get, remote_source).to_return(status: 401, body: "Unauthorized")

        expect { described_class.new(events_url: remote_source, access_token: "expired-token").read_events }
          .to raise_error(OpenURI::HTTPError, /401/)
        expect(token_request).to have_been_requested.once
        expect(events_request).to have_been_requested.twice
      end
    end
  end

  def stub_logger
    instance_double(Logger, info: nil).tap do |log|
      allow(Logger).to receive(:new).and_return(log)
    end
  end

  describe "successful synchronization of a LibCal payload" do
    let(:fixture_body) { file_fixture("libcal_events.json").read }
    let!(:building) { FactoryBot.create(:building, name: "Anderson Hall") }
    let!(:space) { FactoryBot.create(:space, name: "Room 1221", building:) }

    it "creates one event per LibCal event and reports the run summary" do
      log = stub_logger

      expect { described_class.call(response_body: fixture_body) }.to change(Event, :count).by(3)

      expect(log).to have_received(:info).with(a_string_including("LibCal syncing completed with 3 updated and 0 errored records -- with 0 image failures."))
    end

    it "maps an in-person workshop with a managed building and space" do
      described_class.call(response_body: fixture_body)
      event = Event.find_by(guid: "4101")

      expect(event.title).to eq("Intro to Data Visualization")
      expect(event.description.to_plain_text).to eq("Learn the basics of charting your data.")
      expect(event.start_time).to eq(Time.zone.parse("2026-10-05T14:00:00-04:00"))
      expect(event.end_time).to eq(Time.zone.parse("2026-10-05T15:30:00-04:00"))
      expect(event.all_day).to be(false)
      expect(event.registration_link).to eq("https://libcal.example.edu/event/4101")
      expect(event.libcal_categories).to eq("Workshop, Digital Scholarship")
      expect(event.event_type).to be_nil
      expect(event.event_url).to be_nil
      expect(event.building).to eq(building)
      expect(event.space).to eq(space)
      expect(event[:location_space]).to be_nil
      expect(event[:address]).to eq("1114 Polett Walk")
      expect(event[:city]).to eq("Philadelphia")
      expect(event[:state]).to eq("PA")
      expect(event[:zip]).to eq("19122")
      expect(event[:contact_name]).to eq("Pat Example")
      expect(event[:contact_email]).to be_nil
      expect(event.person).to be_nil
    end

    it "maps an online event with a blank presenter and no location" do
      described_class.call(response_body: fixture_body)
      event = Event.find_by(guid: "4102")

      expect(event.event_url).to eq("https://zoom.example.com/j/123456789")
      expect(event.event_type).to eq("Online")
      expect(event.registration_link).to be_nil
      expect(event.libcal_categories).to be_nil
      expect(event[:contact_name]).to eq("Research Services")
      expect(event[:contact_email]).to eq("research@temple.edu")
      expect(event.building).to be_nil
      expect(event[:location_name]).to be_nil
    end

    it "maps an all-day event at an external location" do
      described_class.call(response_body: fixture_body)
      event = Event.find_by(guid: "4103")

      expect(event.all_day).to be(true)
      expect(event.building).to be_nil
      expect(event[:location_name]).to eq("Temple Performing Arts Center")
      expect(event[:address]).to eq("1837 N Broad St")
      expect(event[:contact_name]).to eq("Library Events")
      expect(event.libcal_categories).to eq("Closure")
    end

    it "is idempotent when the same payload is synced again" do
      described_class.call(response_body: fixture_body)

      expect { described_class.call(response_body: fixture_body) }.not_to change(Event, :count)
    end

    it "clears the previous run's image failures after a clean run" do
      Rails.cache.write("events_image_error", ["Stale Event"])

      described_class.call(response_body: fixture_body)

      expect(Rails.cache.read("events_image_error")).to be_nil
    end
  end

  describe "field mapping edge cases" do
    def sync_one(attrs)
      described_class.call(response_body: [{ "id" => 6001, "title" => "Edge Case" }.merge(attrs)].to_json)
      Event.find_by(guid: "6001")
    end

    it "links the presenter to a matching Person" do
      person = FactoryBot.create(:person, first_name: "Jordan", last_name: "Librarian")

      event = sync_one("presenter" => "Jordan Librarian")

      expect(event.person).to eq(person)
    end

    it "falls back to the owner name and email when the presenter is blank" do
      event = sync_one("presenter" => "", "owner" => { "id" => 7, "name" => "Owner Name", "email" => "owner@temple.edu" })

      expect(event[:contact_name]).to eq("Owner Name")
      expect(event[:contact_email]).to eq("owner@temple.edu")
    end

    it "ignores the owner email when a presenter is named" do
      event = sync_one("presenter" => "Pat Example", "owner" => { "id" => 7, "name" => "Owner Name", "email" => "owner@temple.edu" })

      expect(event[:contact_name]).to eq("Pat Example")
      expect(event[:contact_email]).to be_nil
    end

    it "drops blank category names" do
      event = sync_one("category" => [{ "id" => 1, "name" => "Talk" }, { "id" => 2, "name" => "Exhibit" }, { "id" => 3, "name" => " " }])

      expect(event.libcal_categories).to eq("Talk, Exhibit")
    end

    it "stores the featured image alt text" do
      allow(Addrinfo).to receive(:getaddrinfo).and_return([Addrinfo.tcp("93.184.216.34", 443)])
      stub_request(:get, "https://example.com/alt.png").to_return(status: 404)

      event = sync_one("featured_image" => "https://example.com/alt.png", "featured_image_alt_text" => "A poster")

      expect(event.alt_text).to eq("A poster")
    end

    it "leaves times empty when LibCal omits them" do
      event = sync_one({})

      expect(event.start_time).to be_nil
      expect(event.end_time).to be_nil
    end
  end

  describe "updating existing events" do
    it "updates the same record in place" do
      described_class.call(response_body: [{ "id" => 7101, "title" => "Before", "category" => [{ "id" => 1, "name" => "Talk" }] }].to_json)
      original_id = Event.find_by(guid: "7101").id

      described_class.call(response_body: [{ "id" => 7101, "title" => "After" }].to_json)
      event = Event.find_by(guid: "7101")

      expect(event.id).to eq(original_id)
      expect(event.title).to eq("After")
      expect(event.libcal_categories).to be_nil
    end

    it "preserves admin-managed fields that LibCal does not send" do
      existing = FactoryBot.create(:event, guid: "7102", suppress: true, featured: true, tags: "Staff Pick")

      described_class.call(response_body: [{ "id" => 7102, "title" => "Resynced" }].to_json)
      existing.reload

      expect(existing.suppress).to be(true)
      expect(existing.featured).to be(true)
      expect(existing.tags).to eq("Staff Pick")
    end

    it "replaces previously synced values with the blank values LibCal now sends" do
      described_class.call(response_body: [{ "id" => 7103, "title" => "Contact",
                                             "presenter" => "Pat Example",
                                             "owner" => { "id" => 7, "name" => "Library Events" },
                                             "registration" => true,
                                             "url" => { "public" => "https://libcal.example.edu/event/7103" },
                                             "featured_image_alt_text" => "A poster" }].to_json)

      described_class.call(response_body: [{ "id" => 7103, "title" => "Contact",
                                             "presenter" => "",
                                             "owner" => { "id" => 7, "name" => "Library Events" },
                                             "registration" => false,
                                             "url" => { "public" => "https://libcal.example.edu/event/7103" },
                                             "featured_image_alt_text" => "" }].to_json)
      event = Event.find_by(guid: "7103")

      expect(event[:contact_name]).to eq("Library Events")
      expect(event.registration_link).to be_nil
      expect(event.alt_text).to eq("")
    end

    it "clears the stored contact name once the presenter matches a Person" do
      described_class.call(response_body: [{ "id" => 7105, "title" => "Talk", "presenter" => "Jordan Librarian" }].to_json)
      expect(Event.find_by(guid: "7105")[:contact_name]).to eq("Jordan Librarian")

      person = FactoryBot.create(:person, first_name: "Jordan", last_name: "Librarian")
      described_class.call(response_body: [{ "id" => 7105, "title" => "Talk", "presenter" => "Jordan Librarian" }].to_json)
      event = Event.find_by(guid: "7105")

      expect(event.person).to eq(person)
      expect(event[:contact_name]).to be_nil
    end

    it "clears the online url and type when an event is no longer online" do
      described_class.call(response_body: [{ "id" => 7104, "title" => "Hybrid",
                                             "online_join_url" => "https://zoom.example.com/j/9" }].to_json)

      described_class.call(response_body: [{ "id" => 7104, "title" => "Hybrid" }].to_json)
      event = Event.find_by(guid: "7104")

      expect(event.event_url).to be_nil
      expect(event.event_type).to be_nil
    end
  end

  describe "deletion and expiration" do
    it "does not delete events that are missing from a later LibCal payload" do
      described_class.call(response_body: [{ "id" => 7201, "title" => "Kept" }, { "id" => 7202, "title" => "Dropped" }].to_json)

      expect { described_class.call(response_body: [{ "id" => 7201, "title" => "Kept" }].to_json) }
        .not_to change(Event, :count)
      expect(Event.find_by(guid: "7202")).to be_present
    end

    it "keeps past events" do
      body = [{ "id" => 7204, "title" => "Long Ago", "start" => "2020-01-01T10:00:00-05:00", "end" => "2020-01-01T11:00:00-05:00" }].to_json

      expect { described_class.call(response_body: body) }.to change(Event, :count).by(1)
      expect(Event.is_past.find_by(guid: "7204")).to be_present
    end
  end

  describe "empty and malformed responses" do
    def events_from(body)
      described_class.new(response_body: body).read_events
    end

    it "syncs nothing for an empty array" do
      log = stub_logger

      expect { described_class.call(response_body: "[]") }.not_to change(Event, :count)
      expect(log).to have_received(:info).with(a_string_including("completed with 0 updated and 0 errored records"))
    end

    it "syncs nothing for an empty events list" do
      expect { described_class.call(response_body: { events: [] }.to_json) }.not_to change(Event, :count)
    end

    it "reads events from the supported wrapper keys" do
      expect(events_from({ data: [{ id: 1 }] }.to_json)).to eq([{ "id" => 1 }])
      expect(events_from({ items: [{ id: 2 }] }.to_json)).to eq([{ "id" => 2 }])
      expect(events_from({ event: { id: 3 } }.to_json)).to eq([{ "id" => 3 }])
    end

    it "raises on a hash without a recognized events key" do
      expect { described_class.call(response_body: { error: "nope", status: 500 }.to_json) }
        .to raise_error(described_class::UnexpectedResponseShapeException, /Unsupported LibCal response shape: error, status/)
    end

    it "raises on a JSON scalar" do
      expect { described_class.call(response_body: "42") }
        .to raise_error(described_class::UnexpectedResponseShapeException, /Unsupported LibCal response body: Integer/)
    end

    it "raises on invalid JSON without creating events" do
      expect { described_class.call(response_body: "<html>Service Unavailable</html>") }
        .to raise_error(JSON::ParserError)
        .and not_change(Event, :count)
    end
  end

  describe "partial failures" do
    let(:body) do
      [
        { "id" => 7301, "title" => "Good One" },
        { "title" => "No Id" },
        { "id" => 7303, "title" => "Bad Date", "start" => "2026-13-45T10:00:00" },
        { "id" => 7304, "title" => "Good Two" }
      ].to_json
    end

    it "saves the valid events and counts the failures" do
      log = stub_logger

      expect { described_class.call(response_body: body) }.to change(Event, :count).by(2)

      expect(Event.where(guid: %w[7301 7303 7304])).to contain_exactly(
        have_attributes(guid: "7301"), have_attributes(guid: "7304")
      )
      expect(log).to have_received(:info).with(a_string_including("Syncing LibCal Event No Id errored - No LibCal event id found"))
      expect(log).to have_received(:info).with(a_string_including("Syncing LibCal Event Bad Date errored"))
      expect(log).to have_received(:info).with(a_string_including("completed with 2 updated and 2 errored records"))
    end

    it "continues past an event whose save raises" do
      log = stub_logger
      allow_any_instance_of(Event).to receive(:save!).and_wrap_original do |original, *args|
        raise ActiveRecord::RecordNotSaved, "boom" if original.receiver.guid == "7301"

        original.call(*args)
      end

      described_class.call(response_body: [{ "id" => 7301, "title" => "Fails" }, { "id" => 7304, "title" => "Saves" }].to_json)

      expect(Event.where(guid: %w[7301 7304]).pluck(:guid)).to eq(["7304"])
      expect(log).to have_received(:info).with(a_string_including("completed with 1 updated and 1 errored records"))
      expect(log).not_to have_received(:info).with("Successfully saved LibCal record for Fails")
    end
  end

  describe "event sources" do
    it "raises when no source is configured" do
      stub_libcal_config(libcal_events_ids: nil, libcal_events_url: nil)

      expect { described_class.new.read_events }
        .to raise_error(described_class::MissingEventsSourceException, "No LibCal events source configured")
    end

    it "raises when calendar ids are given without a base url" do
      stub_libcal_config(libcal_events_url: nil)

      expect { described_class.new(event_ids: [6197]) }
        .to raise_error(described_class::MissingEventsSourceException, "No LibCal events base URL configured")
    end

    it "requests each configured calendar id with the date window and limit" do
      requests = [6197, 18498].map do |id|
        stub_request(:get, "https://charlesstudy.temple.edu/1.1/events")
          .with(query: hash_including("cal_id" => id.to_s, "limit" => "500"),
                headers: { "Authorization" => "Bearer token" })
          .to_return(status: 200, body: { events: [{ id:, title: "Cal #{id}" }] }.to_json)
      end

      stub_libcal_config(libcal_events_ids: "6197, 18498")

      events = described_class.new(access_token: "token").read_events

      expect(events.map { |event| event["title"] }).to eq(["Cal 6197", "Cal 18498"])
      requests.each { |request| expect(request).to have_been_requested.once }
    end

    it "splits comma-separated urls and de-duplicates events across sources by id" do
      Dir.mktmpdir do |dir|
        first = File.join(dir, "first.json")
        second = File.join(dir, "second.json")
        File.write(first, [{ "id" => 1, "title" => "Shared" }, { "id" => 2, "title" => "Only First" }].to_json)
        File.write(second, { "events" => [{ "id" => "1", "title" => "Shared Again" }, { "id" => 3, "title" => "Only Second" }] }.to_json)

        events = described_class.new(events_url: "#{first}, #{second}").read_events

        expect(events.map { |event| event["title"] }).to eq(["Shared", "Only First", "Only Second"])
      end
    end

    it "aborts the whole run on a LibCal server error without retrying for a token" do
      stub_request(:get, remote_source).to_return(status: 500, body: "Internal Server Error")
      service = described_class.new(events_url: remote_source, access_token: "token")

      expect(service).not_to receive(:fetch_access_token)
      expect { service.sync }.to raise_error(OpenURI::HTTPError, /500/).and not_change(Event, :count)
    end

    it "aborts the whole run when LibCal times out" do
      stub_request(:get, remote_source).to_timeout

      expect { described_class.call(events_url: remote_source, access_token: "token") }
        .to raise_error(Net::OpenTimeout)
    end
  end

  describe "image download guards" do
    it "refuses non-HTTP image urls and records the failure" do
      body = [{ "id" => 7401, "title" => "Local Image", "featured_image" => "file:///etc/passwd" }].to_json

      described_class.call(response_body: body)

      expect(Event.find_by(guid: "7401").image).not_to be_attached
      expect(Rails.cache.read("events_image_error")).to eq(["Local Image"])
    end

    it "records a failure when the image host has no IPv4 address" do
      allow(Addrinfo).to receive(:getaddrinfo).and_return([])
      body = [{ "id" => 7402, "title" => "IPv6 Only", "featured_image" => "https://example.com/v6.png" }].to_json

      described_class.call(response_body: body)

      expect(Event.find_by(guid: "7402").image).not_to be_attached
      expect(Rails.cache.read("events_image_error")).to eq(["IPv6 Only"])
    end
  end

  describe "Honeybadger reporting" do
    before { allow(Honeybadger).to receive(:notify) }

    it "reports a per-event failure with the event id and title" do
      described_class.call(response_body: [{ "title" => "No Id" }].to_json)

      expect(Honeybadger).to have_received(:notify).with(
        instance_of(described_class::MissingEventIdException),
        context: hash_including(libcal_event_id: nil, libcal_event_title: "No Id", libcal_sources: "provided response body")
      )
    end

    it "reports a run-aborting failure with credentials stripped from the source, then re-raises" do
      source = "https://charlesstudy.temple.edu/1.1/events?cal_id=6197&access_token=leaked"
      stub_request(:get, source).to_return(status: 500)

      expect { described_class.call(events_url: source, access_token: "token") }.to raise_error(OpenURI::HTTPError)

      expect(Honeybadger).to have_received(:notify).with(
        instance_of(OpenURI::HTTPError),
        context: { libcal_sources: "https://charlesstudy.temple.edu/1.1/events?cal_id=6197&access_token=[FILTERED]" }
      )
    end

    # The same exception object is re-raised to SyncLibcalEventsJob, whose
    # Honeybadger ActiveJob plugin reports it a second time -- so the raised
    # object itself must already be clean, not just the first notification.
    it "redacts a malformed source's token from the error log line and the re-raised exception" do
      messages = []
      allow(Logger).to receive(:new).and_return(instance_double(Logger).tap do |log|
        allow(log).to receive(:info) { |message| messages << message }
      end)
      source = "https://charlesstudy.temple.edu:port/1.1/events?cal_id=6197&access%5Ftoken=secret"

      raised = nil
      expect { described_class.call(events_url: source, access_token: "token") }
        .to raise_error(URI::InvalidURIError) { |err| raised = err }

      abort_line = messages.find { |message| message.include?("LibCal sync aborted") }
      expect(abort_line).to include("access%5Ftoken=[FILTERED]")
      expect(abort_line).not_to include("secret")
      expect(raised.detailed_message(highlight: false)).not_to include("secret")
      expect(Honeybadger).to have_received(:notify).with(raised, context: hash_including(:libcal_sources))
    end
  end

  describe "run log" do
    it "redacts credentials from the sources named in the opening line" do
      messages = []
      allow(Logger).to receive(:new).and_return(instance_double(Logger).tap do |log|
        allow(log).to receive(:info) { |message| messages << message }
      end)
      source = "https://user:pw@charlesstudy.temple.edu/1.1/events?cal_id=6197&access_token=leaked"

      described_class.new(events_url: source, access_token: "token")

      expect(messages.first).to eq("Syncing LibCal events from https://charlesstudy.temple.edu/1.1/events?cal_id=6197&access_token=[FILTERED]")
    end
  end
end
