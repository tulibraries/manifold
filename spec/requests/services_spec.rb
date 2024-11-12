# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Services", type: :request do
  let(:service) { FactoryBot.create(:service) }

  describe "a request for /service/id when service exists" do
    it "renders the service" do
      get service_path(service.id)
      expect(response.status).to eq(200)
    end
  end

  describe "a request for /services/id when service does not exist" do
    it "renders the service" do
      get service_path(service.id + 1)
      expect(response.status).to eq(404)
    end
  end

  describe "a redirect with a legacy path starting with /services" do
    let(:redirect) {
      FactoryBot.create(:service_redirect)
    }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "a redirect with a legacy path with additional /" do
    let(:redirect) {
      FactoryBot.create(:entity_redirect)
    }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end
end
