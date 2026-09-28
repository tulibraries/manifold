# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::CategoryPage do
  describe ".call" do
    let!(:parent) { FactoryBot.create(:category, slug: "about-page") }
    let!(:child_category) { FactoryBot.create(:category) }
    let!(:webpage) { FactoryBot.create(:webpage) }

    before do
      Categorization.create!(
        category: parent,
        categorizable: child_category
      )

      Categorization.create!(
        category: parent,
        categorizable: webpage
      )
    end

    it "returns only category items" do
      result = described_class.call("about-page")

      expect(result).to contain_exactly(child_category)
    end
  end
end
