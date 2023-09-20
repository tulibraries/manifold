# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServicesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:valid_session) { {} }

  let(:service) { FactoryBot.create(:service) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: service.id }
      expect(response).to render_template("show")
    end

    it "returns html by default success" do
      get :show, params: { id: service.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
