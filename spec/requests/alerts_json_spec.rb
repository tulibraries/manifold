# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AlertsJsons", type: :request do
  before(:all) do
    alert = FactoryBot.create(:alerts_json)
  end

  describe "GET /alerts.json" do
    it "returns http success" do
      get "/alerts.json"
      expect(response.status).to eq(200)
    end
  end
end
