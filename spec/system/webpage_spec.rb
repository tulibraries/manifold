# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Webpages", type: :system do
  describe "Featured Items" do
    scenario "featured item without image" do
      featured_item = FactoryBot.create(:webpage, :with_external_links, slug: "annual-report")
      featured_item.external_link_webpages.first.update("weight" => 1)
      visit(webpage_path(featured_item))
      within(".featured-publication") do
        expect(page).to have_content(featured_item.featured_item.external_link.title)
        expect(page).to have_css("div[class*='featured-publication-without']")
      end
    end

    scenario "featured item with image" do
      webpage = FactoryBot.create(:webpage, :with_external_links, slug: "annual-report")
      webpage.external_link_webpages.first.update("weight" => 1)
      visit(webpage_path(webpage))
      within(".featured-publication") do
        expect(page).to have_content(webpage.featured_item.external_link.image.filename)
      end
    end
  end
end
