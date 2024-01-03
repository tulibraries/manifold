# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::WebPageDrafts", type: :system do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @webpage = FactoryBot.create(:webpage)
    @models = ["webpage"]
  end

  after(:all) do
    Account.destroy_all
    Webpage.destroy_all
  end

  context "New Webpage Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/webpages/new")
      expect(page).to_not have_xpath("//textarea[@id=\"webpage_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"webpage_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"webpage_draft_description\"]")
    end
  end

  context "Visit Webpage Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Webpage Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to have_xpath("//div[@id=\"webpage_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@webpage.description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"webpage_draft_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"webpage_draft_description_trix_input_webpage\")]", visible: false).set(new_description)
      click_button("Update Webpage")
      expect(page).to have_content(@webpage.description.body.to_trix_html)
      expect(page).to_not have_content(new_description)
      visit("/admin/webpages/#{@webpage.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Webpage")
      expect(page).to_not have_content(@webpage.description.body.to_trix_html)
      expect(page).to have_content(new_description)
    end
  end
end
