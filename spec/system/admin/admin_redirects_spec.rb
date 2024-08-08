# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Redirects", type: :system do
  before do
    login_as(FactoryBot.create(:administrator))
  end

  context "Create a redirect" do
    it "adds a space on creation" do
      space = FactoryBot.create(:space, name: "first space")

      visit admin_redirects_path
      click_link "New redirect"

      # Add a required fields
      fill_in "redirect_legacy_path", with: "/space/1"
      fill_in "redirect_manifold_path", with: "/library/scrc"
      select space.name, from: "redirect_redirectable_value"
      click_button "Create Redirect"

      # Expect the new group to be created with the space
      expect(page).to have_link(space.name)
    end
  end

end