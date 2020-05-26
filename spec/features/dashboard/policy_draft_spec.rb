# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::PolicyDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @policy = FactoryBot.create(:policy)
    @models = ["policy"]
  end

  after(:all) do
    Account.destroy_all
    Policy.destroy_all
  end

  context "New Policy Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/policies/new")
      expect(page).to_not have_xpath("//textarea[@id=\"policy_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"policy_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"policy_draft_description\"]")
    end
  end

  context "Visit Policy Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Policy Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to have_xpath("//div[@id=\"policy_description\"]/text()[contains(., \"#{@policy.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"policy_draft_description\"]/text()[contains(., \"#{@policy.draft_description}\")]")
      find("textarea#policy_draft_description").set(new_description)
      click_button("Update Policy")
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to have_xpath("//div[@id=\"policy_description\"]/text()[contains(., \"#{@policy.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"policy_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Policy")
      visit("/admin/policies/#{@policy.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"policy_description\"]/text()[contains(., \"#{@policy.description}\")]")
      expect(page).to have_xpath("//div[@id=\"policy_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
