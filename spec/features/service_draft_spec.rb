# frozen_string_literal: true

require "rails_helper"

RSpec.feature "ServiceDrafts", type: :feature do
  context "Visit Service Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @service = FactoryBot.create(:service)
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
    end
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Service Description" do
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{@service.draft_description}\")]")
      find("textarea#service_draft_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Publish")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Service Access Description" do
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{@service.draft_access_description}\")]")
      find("textarea#service_draft_access_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Publish")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Service Title" do
      find("input#service_draft_title").set(new_description)
      check("Publish")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_title\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Slug" do
      find("input#service_draft_slug").set(new_description)
      check("Publish")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_slug\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Access Link" do
      find("input#service_draft_access_link").set(new_description)
      check("Publish")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_link\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
