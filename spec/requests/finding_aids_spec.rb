# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FindingAids", type: :request, skip: "[TODO] Remove - Redirecting /finding-aids" do

  describe "a redirect with a legacy path starting with /finding_aids" do
    let(:redirect) { FactoryBot.create(:finding_aid_redirect) }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end

end
