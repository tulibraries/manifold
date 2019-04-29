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

  before do
    @account = FactoryBot.create(:account)
  end

	describe "GET index" do
    it "passes all events to the view" do
      event = create(:event)

      locals = capture_view_locals { get :index }
      expect(locals[:resources]).to eq([event])
    end
  end

  describe "GET #edit" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.build(:person, spaces: [space]) }
    let(:original_title) { "Original Title" }
    let(:updated_title) { "Updated Title" }

    before do
      sign_in(@account)

      @event = FactoryBot.create(:event, title: original_title, building: building, space: space, person: person)
      Event.update({ id: @event.id, title: updated_title })
    end

    render_views true

    it "renders edit form with updated values by default" do
      get :edit, params: { id: @event.to_param }
      expect(response.body).to match(updated_title)
    end

    it "renders edit form with original values when selected" do
      get :edit, params: { id: @event.to_param, version: @event.versions.first.to_param }
      expect(response.body).to match(original_title)
    end
  end
end
