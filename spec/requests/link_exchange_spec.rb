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

  context "routes for /r/* (Link Exchanger shortened links)" do
    let(:path) { "/r/872952237291" }

    it "routes to tull.tul-infra.page" do
      get path
      expect(response).to redirect_to("https://tulle.tul-infra.page/r/872952237291")
    end
  end

end
