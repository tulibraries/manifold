# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollectionsController, type: :controller do

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:collection) { FactoryBot.create(:collection) }

    it "returns a success response" do
      get :show, params: { id: collection.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: collection.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
