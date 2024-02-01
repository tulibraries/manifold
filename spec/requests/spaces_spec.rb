# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Spaces", type: :request do
  let(:building) { FactoryBot.create(:building) }
  describe "a redirect with a legacy path starting with /space" do
    let(:redirect) { FactoryBot.create(:space_redirect) }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end
end
