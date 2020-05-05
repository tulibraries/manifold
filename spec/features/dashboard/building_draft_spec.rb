# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::BuildingDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @building = FactoryBot.create(:building)
    @models = ["building"]
  end

  after(:all) do
    Account.destroy_all
    Building.destroy_all
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

  context "Create New Building - Make sure drafts didn't break anything" do
    let(:building) { FactoryBot.build(:building) }

    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/buildings/new")
      fill_in("Name", with: building.name)
      fill_in("Description", with: building.description)
      fill_in("Street Address", with: building.address1)
      fill_in("City, State Zip", with: building.address2)
      fill_in("Coordinates", with: building.coordinates)
      fill_in("Google", with: building.google_id)
      fill_in("Hours Identifier", with: building.hours)
      fill_in("Phone number", with: building.phone_number)
      fill_in("Email", with: building.email)
      click_button("Create Building")
      expect(page).to have_content(building.name)
    end
  end
end
