# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Webpages", type: :system do
  describe "Featured Items" do
    scenario "featured item with image" do
      featured_item = FactoryBot.create(:webpage, :with_file_and_image)
      featured_item.fileabilities.first.update("weight" => 1)
      visit(webpage_path(featured_item))
      within(".featured-publication") do
        expect(page).to have_content(featured_item.featured_item.file_upload.name)
      end
    end

    scenario "featured item without image" do
      webpage = FactoryBot.create(:webpage, :with_files)
      webpage.fileabilities.first.update("weight" => 1)
      visit(webpage_path(webpage))
      within(".featured-publication") do
        expect(page).to have_content(webpage.featured_item.file_upload.name)
        expect(page).to_not have_content(webpage.items.first.file_upload.name)
      end
    end
  end
end
