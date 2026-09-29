# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::ScrcPage do
  describe ".call" do
    let!(:visit_category) do
      FactoryBot.create(:category, slug: "scrc-study")
    end

    let!(:collection_category) do
      FactoryBot.create(:category, slug: "scrc-collections")
    end

    let!(:visit_link) do
      FactoryBot.create(:category, name: "SCRC Visit Link")
    end

    let!(:collection_link) do
      FactoryBot.create(:category, name: "SCRC Collection Link")
    end

    let!(:webpage) do
      FactoryBot.create(:webpage, slug: "scrc")
    end

    let!(:intro) do
      FactoryBot.create(:snippet, slug: "scrc-homepage-intro")
    end

    before do
      Categorization.create!(
        category: visit_category,
        categorizable: visit_link
      )

      Categorization.create!(
        category: collection_category,
        categorizable: collection_link
      )
    end

    it "returns the SCRC page data" do
      result = described_class.call

      expect(result).to eq(
        visit_links: [visit_link],
        collection_links: [collection_link],
        webpage: webpage,
        intro: intro
      )
    end
  end
end
