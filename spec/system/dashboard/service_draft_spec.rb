# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ServiceDrafts", type: :system do
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
      expect(page).to_not have_xpath("//trix-editor[@id=\"service_draft_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//trix-editor[@id=\"service_draft_description\"]")
    end
  end

  context "Visit Service Administrate Page" do
    let(:new_description) { "Don't Panic!" }
    let(:new_access_description) { "Don't Jump! We need you!" }

    scenario "Change the Service Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@service.description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"service_draft_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"service_draft_description_trix_input_service\")]", visible: false).set(new_description)
      click_button("Update Service")
      expect(page).to have_content(@service.description.body.to_trix_html)
      expect(page).to_not have_content(new_description)
      visit("/admin/services/#{@service.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Service")
      expect(page).to_not have_content(@service.description.body.to_trix_html)
      expect(page).to have_content(new_description)
    end

    scenario "Change the Service Access Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//div[@id=\"service_access_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@service.access_description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"service_draft_access_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"service_draft_access_description_trix_input_service\")]", visible: false).set(new_access_description)
      click_button("Update Service")
      expect(page).to have_content(@service.access_description.body.to_trix_html)
      expect(page).to_not have_content(new_access_description)
      visit("/admin/services/#{@service.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Service")
      expect(page).to_not have_content(@service.access_description.body.to_trix_html)
      expect(page).to have_content(new_access_description)
    end
  end
end
