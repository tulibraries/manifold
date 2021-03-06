# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Exhibition", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @exhibition = FactoryBot.create(:exhibition)
    @models = ["exhibition"]
  end

  after(:all) do
    Account.destroy_all
    Exhibition.destroy_all
  end

  context "New Exhibition Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
  end

  context "Edit Exhibition Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_title\"]")
    end
  end

end
