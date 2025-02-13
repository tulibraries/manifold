# frozen_string_literal: true

require "rails_helper"

RSpec.describe "favicon", type: :system do
  describe "favicon" do
    scenario "is present" do
      visit("/contact-us")
      expect(page).to have_selector('head link[rel="icon"]', visible: false)
    end
  end
end
