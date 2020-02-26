# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::SpaceDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @space = FactoryBot.create(:space)
  end

  after(:all) do
    Account.destroy_all
    Space.destroy_all
  end

  context "New Space Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/spaces/new")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_description\"]")
    end
  end

  context "Visit Space Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Space Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to have_xpath("//div[@id=\"space_description\"]/text()[contains(., \"#{@space.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"space_draft_description\"]/text()[contains(., \"#{@space.draft_description}\")]")
      find("textarea#space_draft_description").set(new_description)
      click_button("Update Space")
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to have_xpath("//div[@id=\"space_description\"]/text()[contains(., \"#{@space.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"space_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Space")
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"space_description\"]/text()[contains(., \"#{@space.description}\")]")
      expect(page).to have_xpath("//div[@id=\"space_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
