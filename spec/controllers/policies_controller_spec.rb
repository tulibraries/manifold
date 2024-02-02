# frozen_string_literal: true

require "rails_helper"

RSpec.describe PoliciesController, type: :controller do

  let(:valid_session) { {} }

  let(:policy) { FactoryBot.create(:policy) }

  describe "GET #index" do
    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    it "returns html by default success" do
      get :show, params: { id: policy.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
