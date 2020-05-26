# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::WebPageDrafts", type: :feature do
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
      expect(page).to have_xpath("//div[@id=\"webpage_description\"]/text()[contains(., \"#{@webpage.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"webpage_draft_description\"]/text()[contains(., \"#{@webpage.draft_description}\")]")
      find("textarea#webpage_draft_description").set(new_description)
      click_button("Update Webpage")
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to have_xpath("//div[@id=\"webpage_description\"]/text()[contains(., \"#{@webpage.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"webpage_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Webpage")
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"webpage_description\"]/text()[contains(., \"#{@webpage.description}\")]")
      expect(page).to have_xpath("//div[@id=\"webpage_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
