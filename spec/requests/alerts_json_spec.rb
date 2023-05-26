# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AlertsJsons", type: :request do
  before(:all) do
    alert = FactoryBot.create(:alerts_json)
  end

  describe "GET /show" do
    it "returns http success" do
      get "/alerts_json/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /alerts.json" do
    it "returns http success" do
      get "/alerts.json"
      expect(response.status).to eq(301)
      expect(response.location).to eq("http://www.example.com/alerts_json/show.json")
    end
  end
end
