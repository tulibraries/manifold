# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Webpages", type: :system do

  describe "Featured Items" do
    scenario "featured item with image" do
      webpage = FactoryBot.create(:webpage, :with_external_links, slug: "annual-report")
      webpage.external_link_webpages.first.update("weight" => 1)
      webpage.external_link_webpages.second.update("weight" => 10)
      visit(webpage_path(webpage))
      expect(page).to have_css("div[class*='featured-publication']")
      within(".featured-publication") do
        expect(page).to have_content(webpage.featured_item.external_link.title)
        expect(page).to have_css("img[class*='featured-image']")
      end
    end

    scenario "featured item without image" do
      webpage2 = FactoryBot.create(:webpage, :with_external_links, slug: "annual-report")
      webpage2.external_link_webpages.first.update("weight" => 10)
      webpage2.external_link_webpages.second.update("weight" => 1)
      visit(webpage_path(webpage2))
      expect(page).to have_css("div[class*='featured-publication']")
      within(".featured-publication") do
        expect(page).to_not have_css("img[class*='featured-image']")
      end
    end
  end

  describe "order of lists" do
    scenario "links come before files on same page" do
      webpage3 = FactoryBot.create(:webpage, :with_links_and_files, slug: "annual-report")
      webpage3.external_link_webpages.first.update("weight" => 10)
      visit("/annual-report")
      within(".non-featured-publications") do
        expect(webpage3.external_links.first.title).to appear_before(webpage3.file_uploads.first.label, only_text: true)
      end
    end
  end
end
