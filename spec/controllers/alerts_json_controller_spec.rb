# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlertsJsonController, type: :controller do
  before (:all) do
    @alerts_json = FactoryBot.create(:alerts_json)
  end

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
