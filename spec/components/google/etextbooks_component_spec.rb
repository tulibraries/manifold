# frozen_string_literal: true

require "rails_helper"
require "vcr"

RSpec.describe Google::EtextbooksComponent, type: :component do

  let(:etexts) {
    VCR.use_cassette("etexts", match_requests_on: [:method, :without_api_key]) do
      Google::SheetsConnector.call
    end
  }
  describe "loads data" do
    it "renders results" do
      expect(etexts.values.size > 0).to be_truthy
    end
    it "renders component view" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(etexts:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to be
    end
  end
end
