# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::BuildingDrafts", type: :feature do
  context "New Building Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/buildings/new")
      expect(page).to_not have_xpath("//textarea[@id=\"building_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"building_draft_access_description\"]")
    end
  end

  context "Visit Building Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @building = FactoryBot.create(:building)
      login_as(@account, scope: :account)
      visit("/admin/buildings/#{@building.id}/edit")
    end

    after(:each) do
      @account.destroy
      @building.destroy
    end

    let(:new_description) { "Don't Panic!" }

    scenario "Change the Building Description" do
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"building_draft_description\"]/text()[contains(., \"#{@building.draft_description}\")]")
      find("textarea#building_draft_description").set(new_description)
      click_button("Update Building")
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"building_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Publish")
      click_button("Update Building")
      visit("/admin/buildings/#{@building.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{@building.description}\")]")
      expect(page).to have_xpath("//div[@id=\"building_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
