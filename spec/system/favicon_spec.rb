# frozen_string_literal: true

require "rails_helper"

RSpec.describe "favicon", type: :system do

  before(:all) do
    @highlight_with_image = FactoryBot.create(:highlight, :with_image, title: "Digcol with Image", promote_to_dig_col: true)
    @highlight_without_image = FactoryBot.create(:highlight, title: "Digcol without Image", promote_to_dig_col: true)
  end

  describe "favicon" do
    scenario "is present" do
      visit("/contact-us")
      expect(page).to have_selector('head link[rel="icon"]', visible: false)
    end
  end
end
