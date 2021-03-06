# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildingsController, type: :controller do

  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:building) { FactoryBot.create(:building) }

    it "returns http success" do
      get :show, params: { id: building.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: building.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns html by default success" do
      get :show, params: { id: building.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end


  it_behaves_like "serializable"

end
