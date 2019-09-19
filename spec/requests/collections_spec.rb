# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Collections", type: :request do
  let(:collection) { FactoryBot.create(:collection) }

  describe "a request for /collection/integer when collection exists" do
    it "renders the collection" do
      get collection_path(collection.id)
      expect(response.status).to eq(200)
    end
  end

  describe "a request for /collection/integer when collection does not exist" do
    it "renders the collection" do
      expect { get collection_path(collection.id + 1) }
        .to raise_error(ActionController::RoutingError)
    end
  end


  describe "a redirect with a legacy path starting with /collection" do
    let(:redirect) { FactoryBot.create(:collection_redirect) }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "a redirect with a legacy path with additonal /" do
    let(:legacy_path) { "/collections/blockson/other" }
    let(:redirect) {
      FactoryBot.create(:collection_redirect, legacy_path: legacy_path)
    }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end
end
