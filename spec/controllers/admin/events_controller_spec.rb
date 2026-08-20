# frozen_string_literal: true

require "rails_helper" # ~> LoadError: cannot load such file -- rails_helper

RSpec.describe Admin::EventsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # adjust the attributes here as well.

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EventsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:all) do
    @account = FactoryBot.create(:account, role: "admin")
  end

  describe "GET #edit" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building:) }
    let(:person) { FactoryBot.build(:person) }
    let(:original_title) { "Original Title" }
    let(:updated_title) { "Updated Title" }

    before do
      sign_in(@account)
      @event = FactoryBot.create(:event, title: original_title, building:, space:, person:)
      @event.update!(title: updated_title)
    end

    render_views true

    it "renders edit form with updated values by default" do
      get :edit, params: { id: @event.to_param }
      expect(response.body).to match(updated_title)
    end
  end

  describe "GET #index" do
    before { sign_in(@account) }

    render_views true

    it "labels each event with the system that created it" do
      FactoryBot.create(:event, title: "Legacy Event", guid: "389131")
      FactoryBot.create(:event, title: "LibCal Event", guid: "16528907")

      get :index

      # "Temple" alone would match the site chrome, so assert on the rendered cells.
      expect(response.body).to match(%r{cell-data--event-source-field">.{0,200}?>\s*Temple\s*<}m)
      expect(response.body).to match(%r{cell-data--event-source-field">.{0,200}?>\s*LibCal\s*<}m)
    end
  end

  describe "POST #sync" do
    before do
      sign_in(@account)
      # A full feed sync runs far longer than a request can live, so the action
      # only enqueues it.
      allow(SyncLibcalEventsJob).to receive(:perform_later)
    end

    it "enqueues the LibCal sync and redirects to the admin index" do
      post :sync

      expect(SyncLibcalEventsJob).to have_received(:perform_later)
      expect(response).to redirect_to(admin_events_path)
    end
  end

  describe "GET #index sync reporting" do
    render_views true

    before do
      sign_in(@account)
      # The test env uses a null cache store, so stub the reads the action does.
      allow(Rails.cache).to receive(:read).and_call_original
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::FINISHED_CACHE_KEY).and_return(SyncLibcalEventsJob::SUCCEEDED)
    end

    it "reports a finished sync on the next index load" do
      allow(Rails.cache).to receive(:read).with("events_image_error").and_return(nil)

      get :index

      expect(flash[:notice]).to eq("Events synced")
    end

    it "summarizes image failures without overflowing the 4kb session cookie" do
      titles = Array.new(40) { |i| "A Fairly Long Event Title That Eats Cookie Bytes #{i}" }
      allow(Rails.cache).to receive(:read).with("events_image_error").and_return(titles)

      get :index

      expect(flash[:notice]).to include("40 images could not be retrieved")
      expect(flash[:notice]).to include("and 35 more")
      expect(flash[:notice].bytesize).to be < 1_000
    end

    it "reports a failed sync instead of claiming success" do
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::FINISHED_CACHE_KEY).and_return(SyncLibcalEventsJob::FAILED)

      get :index

      expect(flash[:notice]).to be_nil
      expect(flash[:error]).to include("Events sync failed")
      expect(response.body).not_to include("http-equiv=\"refresh\"")
    end

    it "stays quiet when no sync has finished" do
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::FINISHED_CACHE_KEY).and_return(nil)
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::RUNNING_CACHE_KEY).and_return(nil)

      get :index

      expect(flash[:notice]).to be_nil
      expect(response.body).not_to include("http-equiv=\"refresh\"")
    end

    it "reloads itself while a sync is still running" do
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::FINISHED_CACHE_KEY).and_return(nil)
      allow(Rails.cache).to receive(:read)
        .with(SyncLibcalEventsJob::RUNNING_CACHE_KEY).and_return(true)

      get :index

      expect(flash[:notice]).to eq("Events sync in progress. This page will update when it finishes.")
      expect(response.body).to include("http-equiv=\"refresh\"")
    end
  end
end
