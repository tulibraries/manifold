# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Space", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, role: "admin")
    @non_admin = FactoryBot.create(:account, role: "regular")
    @space = FactoryBot.create(:space)
    @models = ["space"]
  end

  after(:all) do
    Account.destroy_all
    Group.destroy_all
    Space.destroy_all
  end

  context "New Space Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/spaces/new")
      expect(page).to have_xpath("//*[@id=\"space_slug\"]")
      expect(page).to have_xpath("//*[@id=\"space_name\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/spaces/new")
      expect(page).to_not have_xpath("//*[@id=\"space_slug\"]")
      expect(page).to have_xpath("//*[@id=\"space_name\"]")
    end
  end

  context "Edit Space Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to have_xpath("//*[@id=\"space_slug\"]")
      expect(page).to have_xpath("//*[@id=\"space_name\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"space_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"space_name\"]")
    end
  end

end
