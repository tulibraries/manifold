# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::ExternalLinks", type: :system do
  before do
    driven_by(:rack_test)
    admin = FactoryBot.create(:account, admin: true)
    visit new_account_session_path

    fill_in "account_email", with: admin.email
    fill_in "account_password", with: admin.password

    click_button "commit"
  end

  context "When external link is not attached to anything" do
    it "deletes an external link" do
      # Create an external link using FactoryBot
      external_link = FactoryBot.create(:external_link)

      visit admin_external_links_path

      # There should be a link on the page.
      expect(page.all('tr[role="link"]').count).to eq(1)

      # Click the link to destroy the external link
      click_link("Destroy", match: :first)

      expect(page).to have_content("External link was successfully destroyed.")

      # No more links on the page.
      expect(page.all('tr[role="link"]').count).to eq(0)
    end
  end

  context "When external link is attached to a model." do
    it "should not destroy the link and it should alert the user what happened." do

      # Create a webpage with an external link

      web_page = FactoryBot.create(:webpage, :with_external_link)


      visit admin_external_links_path

      # There should be a link on the page:
      expect(page.all('tr[role="link"]').count).to eq(1)

      # Click the link to destroy the external link
      click_link("Destroy", match: :first)

      expect(page).to have_content("External Link could not be deleted.")

      # There should still be a link on the page:
      expect(page.all('tr[role="link"]').count).to eq(1)

    end
  end
end
