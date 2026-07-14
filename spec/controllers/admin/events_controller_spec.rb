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

    it "renders edit form with original values when selected" do
      get :edit, params: { id: @event.to_param, version: @event.versions.last.to_param }
      expect(response.body).to match(original_title)
    end
  end

  describe "POST #sync" do
    before do
      sign_in(@account)
      # Stub out the sync service so we don't actually make http requests to
      # LibCal. We just want to test that we call the service integration correctly.
      allow(::SyncService::LibcalEvents).to receive(:call)
    end
    it "triggers the LibCal sync and redirects to the admin index" do
      post :sync
      expect(::SyncService::LibcalEvents).to have_received(:call)
      expect(response).to redirect_to(admin_events_path)
      expect(flash[:notice]).to eq("Events synced")
    end

    it "summarizes image failures without overflowing the 4kb session cookie" do
      # The test env uses a null cache store, so stub the read the sync action does.
      titles = Array.new(40) { |i| "A Fairly Long Event Title That Eats Cookie Bytes #{i}" }
      allow(Rails.cache).to receive(:read).with("events_image_error").and_return(titles)

      post :sync

      expect(response).to redirect_to(admin_events_path)
      expect(flash[:notice]).to include("40 images could not be retrieved")
      expect(flash[:notice]).to include("and 35 more")
      expect(flash[:notice].bytesize).to be < 1_000
    end
  end
end
