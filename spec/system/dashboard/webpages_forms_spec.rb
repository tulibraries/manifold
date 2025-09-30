# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Webpage", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @webpage = FactoryBot.create(:webpage)
    @models = ["webpage"]
  end

  after(:all) do
    Account.destroy_all
    Webpage.destroy_all
  end

  context "New Webpage Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/webpages/new")
      expect(page).to have_xpath("//*[@id=\"webpage_slug\"]")
      expect(page).to have_xpath("//*[@id=\"webpage_title\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/webpages/new")
      # Non-admin users should be redirected due to authorization
      expect(page).to have_current_path(admin_people_path)
      expect(page).to have_content("You are not authorized to access this page")
    end
  end

  context "Edit Webpage Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to have_xpath("//*[@id=\"webpage_slug\"]")
      expect(page).to have_xpath("//*[@id=\"webpage_title\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/webpages/#{@webpage.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"webpage_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"webpage_title\"]")
    end
  end

end
