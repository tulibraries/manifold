# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpacesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:space) { FactoryBot.create(:space) }

  describe "GET #index" do

    it "returns a 404 when html is requested" do
      get :index
      expect(response).to have_http_status(404)
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: space.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: space.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
