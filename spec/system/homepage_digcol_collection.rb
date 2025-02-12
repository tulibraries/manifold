# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Highlight", type: :system do

  before(:all) do
    Highlight.delete_all
    @highlight_with_image = FactoryBot.create(:highlight, :with_image, title: "Digcol with Image", promote_to_dig_col: true)
    @highlight_without_image = FactoryBot.create(:highlight, title: "Digcol without Image", promote_to_dig_col: true)
  end

  after(:all) do
    Highlight.delete_all
  end

  describe "Homepage display" do
    scenario "Highlight appears on page" do
      visit(root_path)
      within("#news-events") do
        expect(page).to have_content(@highlight_with_image.title)
      end
    end

    scenario "Highlight without image does not appear on page" do
      visit(root_path)
      within("#news-events") do
        expect(page).to_not have_content(@highlight_without_image.title)
      end
    end
  end

end
