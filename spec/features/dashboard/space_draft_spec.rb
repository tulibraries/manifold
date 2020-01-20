# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::SpaceDrafts", type: :feature do
  context "New Space Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/spaces/new")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_access_description\"]")
    end
  end

  context "Visit Space Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @space = FactoryBot.create(:space)
      login_as(@account, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
    end

    after(:each) do
      @account.destroy
      @space.destroy
    end

    let(:new_description) { "Don't Panic!" }

    scenario "Change the Space Description" do
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
