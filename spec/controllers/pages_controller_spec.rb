require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  let(:page) { FactoryBot.create(:page) }

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
    let(:page) { FactoryBot.create(:page) }

    it "returns a success response", skip: "TBA: No views exist" do
      get :show, params: { id: page.to_param }
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: page.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show as JSON" do
    let(:page) { FactoryBot.create(:page) }

    it "returns valid json" do
      get :show, format: :json, params: { id: page.id }
      Tempfile.open(["serialized_page_", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/page_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end

end
