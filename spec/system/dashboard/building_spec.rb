# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Building", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @building = FactoryBot.create(:building)
    @models = ["building"]
  end

  context "New Building Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/buildings/new")
      expect(page).to have_xpath("//*[@id=\"building_slug\"]")
      expect(page).to have_xpath("//*[@id=\"building_name\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/buildings/new")
      expect(page).to_not have_xpath("//*[@id=\"building_slug\"]")
      expect(page).to have_xpath("//*[@id=\"building_name\"]")
    end
  end

  context "Building SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/buildings/#{@building.id}")
      expect(page).to have_text("/libraries/#{@building.id}")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to have_xpath("//*[@id=\"building_slug\"]")
      expect(page).to have_xpath("//*[@id=\"building_name\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"building_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"building_name\"]")
    end
  end

end
