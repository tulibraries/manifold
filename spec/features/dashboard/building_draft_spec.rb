# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::BuildingDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @building = FactoryBot.create(:building)
  end

  after(:all) do
    @account.destroy
    @building.destroy
  end

  context "New Building Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/buildings/new")
      expect(page).to_not have_xpath("//textarea[@id=\"building_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"building_draft_access_description\"]")
    end
  end

  context "Show draftable if draftable feature flag set" do
    scenario "Enable draftable" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to have_xpath("//textarea[@id=\"building_draft_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"building_draft_description\"]")
    end
  end

  context "Visit Building Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Building Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"building_draft_description\"]/text()[contains(., \"#{@building.draft_description}\")]")
      find("textarea#building_draft_description").set(new_description)
      click_button("Update Building")
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"building_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Building")
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
