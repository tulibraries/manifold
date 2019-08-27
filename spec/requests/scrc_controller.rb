# frozen_string_literal: true

require "rails_helper"

RSpec.describe ScrcController, type: :request do

  describe "request for a path that is a finding aid" do
    let(:finding_aid) { FactoryBot.create(:finding_aid) }
    it "redirects to the finding aid controller" do
      get "/scrc/a-finding-aid"
      expect(response).to redirect_to(finding_aid_path(finding_aid))
    end
  end

  describe "request for a path that is a redirect" do
    it "redirects to the the expected redirect" do
      let(:redirect) { FactoryBot.create(:entity_redirect) }
      get redirect.legacy_path
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "request for a path that a finding aid or redirect" do
    it "404s" do
      get "/scrc/nopesauce"
      expect(response).to redirect_to("errors#not_found")
    end
  end
end
