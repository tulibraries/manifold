# frozen_string_literal: true

require "rails_helper"

RSpec.describe RedirectsController, type: :controller do

  describe "GET redirect to a static path" do
    let(:redirect) { FactoryBot.create(:static_redirect) }
    it "redirects to the expected path" do
      get :show, params: { path: redirect.legacy_path }
      expect(response).to redirect_to(redirect.path)
    end
    it "redirects has the 301 status" do
      get :show, params: { path: redirect.legacy_path }
      expect(response.status).to eq(301)
    end
  end

  describe "GET redirect to another entity" do
    let(:redirect) { FactoryBot.create(:entity_redirect) }
    it "redirects to the expected path" do
      get :show, params: { path: redirect.legacy_path }
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "GET a non defined redirect" do
    it "redirects to a 404" do
      expect { get(:show, params: { path: "not-defined" }) }.
        to raise_error(ActionController::RoutingError)
    end
  end
end
