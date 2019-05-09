require 'rails_helper'

RSpec.describe HighlightsController, type: :controller do

  let(:highlight) { FactoryBot.create(:highlight) }

  describe "GET #index" do
    it "returns a success response", skip: "TBA: No views exist" do
      get :index
      expect(response).to be_successful
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:highlight) { FactoryBot.create(:highlight) }

    it "returns a success response", skip: "TBA: No views exist" do
      get :show, params: { id: highlight.to_param }
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: highlight.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:highlight) { FactoryBot.create(:highlight) }

    it "returns valid json" do
      get :show, format: :json, params: { id: highlight.id }
      Tempfile.open(["serialized_highlight_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/highlight_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
