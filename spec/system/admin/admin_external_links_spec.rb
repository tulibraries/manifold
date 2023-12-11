# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::ExternalLinks", type: :system do
  before do
    login_as(FactoryBot.create(:administrator))
  end

  context "When external link is not attached to anything" do
    it "deletes an external link" do
      external_link = FactoryBot.create(:external_link)
      
      visit admin_external_links_path
      expect(page.all('tr[role="link"]').count).to eq(1)

      click_link("Destroy", match: :first)
      expect(page).to have_content("External link was successfully destroyed.")
      expect(page.all('tr[role="link"]').count).to eq(0)
    end
  end

  context "When external link is attached to a model." do
    it "should not destroy the link and it should alert the user what happened." do
      web_page = FactoryBot.create(:webpage, :with_external_link)

      visit admin_external_links_path
      expect(page.all('tr[role="link"]').count).to eq(1)

      click_link("Destroy", match: :first)
      expect(page).to have_content("External Link could not be deleted.")
      expect(page.all('tr[role="link"]').count).to eq(1)
    end
  end
end
