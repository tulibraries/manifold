# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::ExhibitionDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @exhibition = FactoryBot.create(:exhibition)
    @models = ["exhibition"]
  end

  after(:all) do
    Account.destroy_all
    Exhibition.destroy_all
  end

  context "New Exhibition Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to_not have_xpath("//textarea[@id=\"exhibition_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"exhibition_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"exhibition_draft_description\"]")
    end
  end

  context "Visit Exhibition Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Exhibition Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"exhibition_draft_description\"]/text()[contains(., \"#{@exhibition.draft_description}\")]")
      find("textarea#exhibition_draft_description").set(new_description)
      click_button("Update Exhibition")
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"exhibition_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Exhibition")
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
