# frozen_string_literal: true

require "rails_helper"
require "vcr"

RSpec.describe Google::EtextbooksComponent, type: :component do

  let(:etexts) {
    VCR.use_cassette("etexts") do
      Google::SheetsConnector.call(feature: "etexts")
    end
  }
  let!(:intro) { FactoryBot.create(:snippet, slug: "past-event-videos-intro") }

  describe "loads data" do
    it "renders results" do
      expect(etexts.values.size > 0).to be_truthy
    end
    it "renders ordered asc by course" do
      page = render_inline(described_class.new(etexts:, title: intro.title, description: intro.description, column: "course", direction: "asc"))
      expect(page.text).to match "AAAS 1253-701"
      expect(page.text).to match "THTR 0907-001"
      expect(page.text.index("AAAS 1253-701")).to be < page.text.index("THTR 0907-001")
    end
    it "renders ordered desc by course" do
      page = render_inline(described_class.new(etexts:, title: intro.title, description: intro.description, column: "course", direction: "desc"))
      expect(page.text).to match "AAAS 1253-701"
      expect(page.text).to match "THTR 0907-001"
      expect(page.text.index("THTR 0907-001")).to be < page.text.index("AAAS 1253-701")
    end
    it "renders ordered asc by prof" do
      page = render_inline(described_class.new(etexts:, title: intro.title, description: intro.description, column: "professor", direction: "asc"))
      expect(page.text).to match "Aaronson"
      expect(page.text).to match "Wager"
      expect(page.text.index("Aaronson")).to be < page.text.index("Wager")
    end
    it "renders ordered desc by prof" do
      page = render_inline(described_class.new(etexts:, title: intro.title, description: intro.description, column: "professor", direction: "desc"))
      expect(page.text).to match "Aaronson"
      expect(page.text).to match "Wager"
      expect(page.text.index("Wager")).to be < page.text.index("Aaronson")
    end
  end
end
