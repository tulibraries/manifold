# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Service", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @service = FactoryBot.create(:service)
    @models = ["service"]
  end

  after(:all) do
    Account.destroy_all
    Service.destroy_all
  end

  context "New Service Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/services/new")
      expect(page).to have_xpath("//*[@id=\"service_slug\"]")
      expect(page).to have_xpath("//*[@id=\"service_title\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/services/new")
      expect(page).to_not have_xpath("//*[@id=\"service_slug\"]")
      expect(page).to have_xpath("//*[@id=\"service_title\"]")
    end
  end

  context "Edit Service Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to have_xpath("//*[@id=\"service_slug\"]")
      expect(page).to have_xpath("//*[@id=\"service_title\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/services/#{@service.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"service_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"service_title\"]")
    end
  end

end
