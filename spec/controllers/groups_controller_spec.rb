# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:group) { FactoryBot.create(:group) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: group.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show as JSON" do
    let(:group) { FactoryBot.create(:group) }

    it "returns valid json" do
      get :show, format: :json, params: { id: group.id }
      Tempfile.open(["serialized_group", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/group_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end

end
