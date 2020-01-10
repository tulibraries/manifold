# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::ExhibitionDrafts", type: :feature do
  context "New Exhibition Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to_not have_xpath("//textarea[@id=\"exhibition_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"exhibition_draft_access_description\"]")
    end
  end

  context "Visit Exhibition Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @exhibition = FactoryBot.create(:exhibition)
      login_as(@account, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
    end

    after(:each) do
      @account.destroy
      @exhibition.destroy
    end

    let(:new_description) { "Don't Panic!" }

    scenario "Change the Exhibition Description" do
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"exhibition_draft_description\"]/text()[contains(., \"#{@exhibition.draft_description}\")]")
      find("textarea#exhibition_draft_description").set(new_description)
      click_button("Update Exhibition")
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"exhibition_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check("Publish")
      click_button("Update Exhibition")
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{@exhibition.description}\")]")
      expect(page).to have_xpath("//div[@id=\"exhibition_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
