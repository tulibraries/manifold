# frozen_string_literal: true

require "rails_helper"

RSpec.feature "ServiceDrafts", type: :feature do
  context "Visit Service Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @service = FactoryBot.create(:service)
      login_as(@account, scope: :account)
    end
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Service Description" do
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_description") do
        expect(page).to have_text @service.description
      end
      within("textarea#service_draft_description") do
        expect(page).to have_text @service.draft_description
      end
      find("textarea#service_draft_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_description") do
        expect(page).to have_text @service.description
      end
      within("textarea#service_draft_description") do
        expect(page).to have_text new_description
      end
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_description") do
        expect(page).to_not have_text @service.description
        expect(page).to have_text new_description
      end
    end

    scenario "Change the Service Access Description" do
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_access_description") do
        expect(page).to have_text @service.access_description
      end
      within("textarea#service_draft_access_description") do
        expect(page).to have_text @service.draft_access_description
      end
      find("textarea#service_draft_access_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_access_description") do
        expect(page).to have_text @service.access_description
      end
      within("textarea#service_draft_access_description") do
        expect(page).to have_text new_description
      end
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("div#service_access_description") do
        expect(page).to_not have_text @service.access_description
        expect(page).to have_text new_description
      end
    end

    scenario "Change the Service Title" do
      skip
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//input[@id=\"service_title\" and @value=\"#{@service.title}\"]")

      find("input#service_title").set(new_description)
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//input[@id=\"service_title\" and @value=\"#{@service.title}\"]")
    end
  end
end
