# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlertsJsonController, type: :controller do
  let (:message) { "Test Message" }
  let (:alerts_json) { FactoryBot.create(:alerts_json) }

  describe "GET #index" do
    it "returns json when requested" do
      alerts_json.update(message: "#{message}")
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
