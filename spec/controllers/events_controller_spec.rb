# frozen_string_literal: true

require "rails_helper"
require "tempfile"

RSpec.describe EventsController, type: :controller do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, buildings: [building]) }

  let(:event) {
    FactoryBot.create(:event, building: building, space: space, person: person)
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "returns html by default" do
      get :index
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: event.id }
      expect(response).to render_template("show")
    end

    it "returns html by default" do
      get :show, params: { id: event.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :show, format: :json, params: { id: event.id }
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
