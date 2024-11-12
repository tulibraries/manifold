# frozen_string_literal: true

require "rails_helper"

RSpec.describe RedirectsController, type: :request do

  describe "GET redirect to a static path" do
    let(:redirect) { FactoryBot.create(:static_redirect) }
    it "redirects to the expected path" do
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
    end
    it "redirects has the 301 status" do
      get redirect.legacy_path
      expect(response.status).to eq(301)
    end
  end

  describe "GET redirect to another entity" do
    let(:redirect) { FactoryBot.create(:entity_redirect) }
    it "redirects to the expected path" do
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "GET redirect to external url" do
    let(:redirect) { FactoryBot.create(:full_url_redirect) }
    it "redirects to the expected url" do
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "GET a non defined redirect" do
    it "redirects to a 404" do
      get("/not-defined")
      expect(response.status).to eq(404)
    end
  end

  describe "GET a collection of finding-aids" do
    it "redirects to a 3rd party host" do
      get("/finding-aids?collection=777")
      expect(response).to redirect_to(I18n.t("manifold.default.finding_aids_new_home"))
    end
  end

  describe "GET redirect with no message specified" do
    let(:redirect) { FactoryBot.create(:static_redirect, no_message: true) }
    it "redirects with no message displayed" do
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
      expect(flash[:notice]).to_not be_present
    end
  end

  describe "GET redirect with message specified" do
    let(:redirect) { FactoryBot.create(:static_redirect) }
    it "redirects with message displayed" do
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
      expect(flash[:notice]).to be_present
    end
  end
end
