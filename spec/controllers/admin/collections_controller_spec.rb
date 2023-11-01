# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CollectionsController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }
  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }
  let(:valid_session) { {} }

  let(:account) { FactoryBot.create(:account, admin: true) }
  let(:finding_aid) { FactoryBot.create(:finding_aid) }
  let!(:collection) { FactoryBot.create(:collection, finding_aids: [finding_aid]) }

  describe "GET #index" do
    it "returns a success response" do
      Collection.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      collection = Collection.create! valid_attributes
      get :show, params: { id: collection.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    render_views true
    it "does not allow collection deleted if finding_aids attached" do
      sign_in(account)
      expect { delete :destroy, params: { id: collection.id } }.to_not change(Collection, :count)
      expect(flash[:notice]).to match(collection.name)
    end
  end
end
