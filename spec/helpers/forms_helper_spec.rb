# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormsHelper, type: :helper do
  describe "#breadcrumb_link" do
    before do
      allow(helper).to receive(:webpages_scrc_path).and_return("/scrc")
      allow(helper).to receive(:forms_path).and_return("/forms")
    end

    it "returns the SCRC link for copy requests" do
      result = helper.breadcrumb_link("copy-requests")

      expect(result).to include("SCRC Homepage")
      expect(result).to include("href=\"/scrc\"")
    end

    it "returns the SCRC link for av requests" do
      result = helper.breadcrumb_link("av-requests")

      expect(result).to include("SCRC Homepage")
      expect(result).to include("href=\"/scrc\"")
    end

    it "returns the general forms link for other types" do
      result = helper.breadcrumb_link("something-else")

      expect(result).to include("View all forms")
      expect(result).to include("href=\"/forms\"")
    end
  end
end
