# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::FindingAidDrafts", type: :feature do
  before(:all) do
    Rails.configuration.draftable = true
    @account = FactoryBot.create(:account, admin: true)
    @finding_aid = FactoryBot.create(:finding_aid)
  end

  after(:all) do
    @account.destroy
    @finding_aid.destroy
  end

  context "New Finding_Aid Administrate Page" do
    scenario "Create new item " do
      login_as(@account, scope: :account)
      visit("/admin/finding_aids/new")
      expect(page).to_not have_xpath("//textarea[@id=\"finding_aid_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"finding_aid_draft_access_description\"]")
    end
  end

  context "Show draftable if draftable feature flag set" do
    scenario "Enable draftable" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to have_xpath("//textarea[@id=\"finding_aid_draft_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"finding_aid_draft_description\"]")
    end
  end


  context "Visit Finding Aid Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Finding Aid Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to have_xpath("//div[@id=\"findingaid_description\"]/text()[contains(., \"#{@finding_aid.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"finding_aid_draft_description\"]/text()[contains(., \"#{@finding_aid.draft_description}\")]")
      find("textarea#finding_aid_draft_description").set(new_description)
      click_button("Update Finding aid")
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to have_xpath("//div[@id=\"findingaid_description\"]/text()[contains(., \"#{@finding_aid.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"finding_aid_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Finding aid")
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"findingaid_description\"]/text()[contains(., \"#{@finding_aid.description}\")]")
      expect(page).to have_xpath("//div[@id=\"findingaid_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
