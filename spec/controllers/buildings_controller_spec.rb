# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildingsController, type: :controller do

  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:building) { FactoryBot.create(:building) }

    it "returns http success" do
      get :show, params: { id: building.id }
      expect(response).to have_http_status(:ok)
    end
  end

end
