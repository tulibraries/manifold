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
    @account = FactoryBot.create(:account)
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

  describe "GET #sync" do
    let (:event) { FactoryBot.create(:event) }
    before do
      sign_in(@account)
      # Stub out the sync service so we don't actually make
      # http requests for XML. We jut want to test that
      # we are calling the service integration correctly
      allow(::SyncService::Events).to receive(:call)
    end
    it "renders edit form" do
      post :sync
      expect(::SyncService::Events).to have_received(:call).with(force: true)
    end
  end
end
