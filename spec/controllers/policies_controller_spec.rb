# frozen_string_literal: true

require "rails_helper"

RSpec.describe PoliciesController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  let(:policy) { FactoryBot.create(:policy) }

  describe "GET #index" do
    it "returns a success response" do
      Policy.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      policy = Policy.create! valid_attributes
      get :show, params: { id: policy.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: policy.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    it "returns valid json" do
      get :show, format: :json, params: { id: policy.id }
      Tempfile.open(["serialized_policy_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/policy_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
