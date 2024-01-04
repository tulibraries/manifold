# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::FindingAid", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @finding_aid = FactoryBot.create(:finding_aid)
    @models = ["finding_aid"]
  end

  after(:all) do
    Account.destroy_all
    FindingAid.destroy_all
  end

  context "New Finding Aid Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/finding_aids/new")
      expect(page).to have_xpath("//*[@id=\"finding_aid_slug\"]")
      expect(page).to have_xpath("//*[@id=\"finding_aid_name\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/finding_aids/new")
      expect(page).to_not have_xpath("//*[@id=\"finding_aid_slug\"]")
      expect(page).to have_xpath("//*[@id=\"finding_aid_name\"]")
    end
  end

  context "Edit Finding Aid Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to have_xpath("//*[@id=\"finding_aid_slug\"]")
      expect(page).to have_xpath("//*[@id=\"finding_aid_name\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"finding_aid_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"finding_aid_name\"]")
    end
  end

end
