# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AlertsJsons", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/alerts_json/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /alerts.json" do
    it "returns http success" do
      get "/alerts.json"
      expect(response).to have_http_status(:success)
    end
  end
end
