# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpacesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:space) { FactoryBot.create(:space) }

  # describe "GET #index" do
  #   it "returns http success" do
  #     get :index
  #     expect(response).to have_http_status(:ok)
  #   end

  #   it "returns json when requested" do
  #     get :index, format: :json
  #     expect(response.header["Content-Type"]).to include "json"
  #   end
  # end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: space.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: space.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    it "returns valid json" do
      get :show, format: :json, params: { id: space.id }
      Tempfile.open(["serialized_space_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/space_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
