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
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{@service.draft_description}\")]")
      find("textarea#service_draft_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Service Access Description" do
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{@service.draft_access_description}\")]")
      find("textarea#service_draft_access_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{new_description}\")]")
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
