# frozen_string_literal: true

require "rails_helper"

RSpec.feature "ServiceDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @service = FactoryBot.create(:service)
    @models = ["service"]
  end

  after(:all) do
    Account.destroy_all
    Service.destroy_all
  end

  context "New Service Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/services/new")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_access_description\"]")
    end
  end

  context "Visit Service Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Service Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{@service.draft_description}\")]")
      find("textarea#service_draft_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{@service.description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/text()[contains(., \"#{new_description}\")]")
    end

    scenario "Change the Service Access Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{@service.draft_access_description}\")]")
      find("textarea#service_draft_access_description").set(new_description)
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"service_draft_access_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
