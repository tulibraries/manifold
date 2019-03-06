# frozen_string_literal: true

require "rails_helper"
require "tempfile"

RSpec.describe EventsController, type: :controller do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

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
      get :show, params: { id: event.to_param }
      expect(response).to render_template("show")
    end

    it "returns html by default" do
      get :show, params: { id: event.to_param }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :show, format: :json, params: { id: event.to_param }
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:event) { FactoryBot.create(:event, :with_image) }

    it "returns valid json" do
      get :show, format: :json, params: { id: event.id }
      Tempfile.open(["serialized_event-", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args =  %W[validate -s app/schemas/event_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
