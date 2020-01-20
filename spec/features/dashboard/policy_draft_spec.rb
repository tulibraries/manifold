# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::PolicyDrafts", type: :feature do
  context "New Policy Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/policies/new")
      expect(page).to_not have_xpath("//textarea[@id=\"policy_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"policy_draft_access_description\"]")
    end
  end

  context "Visit Policy Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @policy = FactoryBot.create(:policy)
      login_as(@account, scope: :account)
      visit("/admin/policies/#{@policy.id}/edit")
    end

    after(:each) do
      @account.destroy
      @policy.destroy
    end

    let(:new_description) { "Don't Panic!" }

    scenario "Change the Policy Description" do
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
