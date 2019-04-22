# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonsController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:person) { FactoryBot.create(:person) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
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
    it "returns http success" do
      get :show, params: { id: person.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: person.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns html by default success" do
      get :show, params: { id: person.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:person) { FactoryBot.create(:person, :with_image) }

    it "returns valid json" do
      get :show, format: :json, params: { id: person.to_param }
      Tempfile.open(["serialized_person", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/person_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
