# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsController, type: :controller do

  let(:finding_aid) { FactoryBot.create(:finding_aid) }

  describe "GET #index" do
    let(:finding_aid) { FactoryBot.create(:finding_aid) }

    it "returns a success response", skip: "TBA: Views don't exist yet" do
      get :index
      expect(response).to be_successful
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: finding_aid.id }
      expect(response).to be_successful
    end

    it "returns json for finding aid" do
      get :show, params: { id: finding_aid.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:finding_aid) { FactoryBot.create(:finding_aid) }

    it "returns valid json" do
      get :show, format: :json, params: { id: finding_aid.id }
      Tempfile.open(["serialized_finding_aid_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/finding_aid_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
