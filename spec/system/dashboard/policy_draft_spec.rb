# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::PolicyDrafts", type: :system do
  before(:all) do
    @account = FactoryBot.create(:account, role: "admin")
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
      expect(page).to have_xpath("//div[@id=\"policy_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@policy.description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"policy_draft_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"policy_draft_description_trix_input_policy\")]", visible: false).set(new_description)
      click_button("Update Policy")
      expect(page).to have_content(@policy.description.body.to_trix_html)
      expect(page).to_not have_content(new_description)
      visit("/admin/policies/#{@policy.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Policy")
      expect(page).to_not have_content(@policy.description.body.to_trix_html)
      expect(page).to have_content(new_description)
    end
  end
end
