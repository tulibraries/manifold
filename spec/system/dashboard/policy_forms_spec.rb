# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Policy", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @policy = FactoryBot.create(:policy)
    @models = ["policy"]
  end

  after(:all) do
    Account.destroy_all
    Policy.destroy_all
  end

  context "New Policy Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/policies/new")
      expect(page).to have_xpath("//*[@id=\"policy_slug\"]")
      expect(page).to have_xpath("//*[@id=\"policy_name\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/policies/new")
      expect(page).to_not have_xpath("//*[@id=\"policy_slug\"]")
      expect(page).to have_xpath("//*[@id=\"policy_name\"]")
    end
  end

  context "Edit Policy Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to have_xpath("//*[@id=\"policy_slug\"]")
      expect(page).to have_xpath("//*[@id=\"policy_name\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"policy_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"policy_name\"]")
    end
  end

end
