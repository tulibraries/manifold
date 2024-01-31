# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExhibitionsController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExhibitionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:exhibition) { FactoryBot.create(:exhibition) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:exhibition) { FactoryBot.create(:exhibition) }

    it "returns a success response" do
      get :show, params: { id: exhibition.to_param }, session: valid_session
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: exhibition.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
