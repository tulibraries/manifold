# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FindingAids", type: :request do
  let(:finding_aid_not_showable) { FactoryBot.create(:finding_aid) }
  let(:finding_aid_showable) { FactoryBot.create(:finding_aid, holdover: true) }
  let(:redirect) { FactoryBot.create(:finding_aid_redirect) }

  describe "a redirect with a legacy path starting with /finding_aids" do
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end

  describe "only holdover aids get shown" do
    it "does not return a success response for non-holdovers" do
      get finding_aid_path(finding_aid_showable)
      expect(response).to be_successful
    end
    it "does not return a success response for non-holdovers" do
      get finding_aid_path(finding_aid_not_showable)
      expect(response).to_not be_successful
    end
  end

end
