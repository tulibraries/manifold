# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::CategoryDrafts", type: :feature do
  context "New Category Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/categories/new")
      expect(page).to_not have_xpath("//textarea[@id=\"category_draft_long_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"category_draft_access_description\"]")
    end
  end

  context "Visit Category Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @category = FactoryBot.create(:category)
      login_as(@account, scope: :account)
      visit("/admin/categories/#{@category.id}/edit")
    end

    after(:each) do
      @account.destroy
      @category.destroy
    end

    let(:new_long_description) { "Don't Panic!" }

    scenario "Change the Category Long Description" do
      expect(page).to have_xpath("//div[@id=\"category_long_description\"]/text()[contains(., \"#{@category.long_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"category_draft_long_description\"]/text()[contains(., \"#{@category.draft_long_description}\")]")
      find("textarea#category_draft_long_description").set(new_long_description)
      click_button("Update Category")
      visit("/admin/categories/#{@category.id}/edit")
      expect(page).to have_xpath("//div[@id=\"category_long_description\"]/text()[contains(., \"#{@category.long_description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"category_draft_long_description\"]/text()[contains(., \"#{new_long_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Category")
      visit("/admin/categories/#{@category.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"category_long_description\"]/text()[contains(., \"#{@category.long_description}\")]")
      expect(page).to have_xpath("//div[@id=\"category_long_description\"]/text()[contains(., \"#{new_long_description}\")]")
    end
  end
end
