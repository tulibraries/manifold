# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsController, type: :controller do

  let(:finding_aid) { FactoryBot.create(:finding_aid, holdover: true) }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: finding_aid.id }
      expect(response).to be_successful
    end

    it "returns json for finding aid" do
      get :show, params: { id: finding_aid.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
