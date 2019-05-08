# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServicesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:valid_session) { {} }

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }
  let(:group) { FactoryBot.create(:group, space: space, chair_dept_heads: [chair_person]) }
  let(:service) { FactoryBot.create(:service, related_spaces: [space], related_groups: [group]) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: service.id }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: service.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:service) { FactoryBot.create(:service) }
    it "returns valid json" do
      get :show, format: :json, params: { id: service.id }
      Tempfile.open(["serialized_service_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/service_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
