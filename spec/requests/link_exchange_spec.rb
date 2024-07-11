# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Link Exchanger routing", type: :request do
  context "routes for /link_exchange" do
    let(:path) { "/link_exchange" }

    it "routes to tull.tul-infra.page" do
      get path
      expect(response).to redirect_to("https://tulle.tul-infra.page")
    end
  end

  context "routes for /link_exchange/*" do
    let(:path) { "/link_exchange/foo/bar" }

    it "routes to tull.tul-infra.page" do
      get path
      expect(response).to redirect_to("https://tulle.tul-infra.page/foo/bar")
    end
  end
end
