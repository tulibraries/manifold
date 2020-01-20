# frozen_string_literal: true

require "rails_helper"

RSpec.feature "ServiceDrafts", type: :feature do
  context "New Service Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/services/new")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"service_draft_access_description\"]")
    end
  end

  context "Visit Service Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @service = FactoryBot.create(:service)
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
    end

    after(:each) do
      @account.destroy
      @service.destroy
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
      check(I18n.t("manifold.admin.actions.publish"))
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
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{@service.access_description}\")]")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
