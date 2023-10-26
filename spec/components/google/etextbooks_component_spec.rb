# frozen_string_literal: true

require "rails_helper"

RSpec.describe Google::EtextbooksComponent, type: :component do
  before(:all) do
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end
  end

  let(:etexts) { Google::SheetsConnector.call }

  describe "loads data" do
    it "renders results" do
      expect(etexts.values.length > 0).to be_truthy
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
