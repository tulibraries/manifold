# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::FindingAidDrafts", type: :system do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @finding_aid = FactoryBot.create(:finding_aid)
    @models = ["finding_aid"]
  end

  after(:all) do
    Account.destroy_all
    FindingAid.destroy_all
  end

  context "New Finding_Aid Administrate Page" do
    scenario "Create new item " do
      login_as(@account, scope: :account)
      visit("/admin/finding_aids/new")
      expect(page).to_not have_xpath("//textarea[@id=\"finding_aid_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"finding_aid_draft_access_description\"]")
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
      expect(page).to have_xpath("//div[@id=\"findingaid_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@finding_aid.description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"finding_aid_draft_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"finding_aid_draft_description_trix_input_finding_aid\")]", visible: false).set(new_description)
      click_button("Update Finding aid")
      expect(page).to have_content(@finding_aid.description.body.to_trix_html)
      expect(page).to_not have_content(new_description)
      visit("/admin/finding_aids/#{@finding_aid.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Finding aid")
      expect(page).to_not have_content(@finding_aid.description.body.to_trix_html)
      expect(page).to have_content(new_description)
    end
  end
end
