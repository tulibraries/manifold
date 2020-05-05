# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::CategoryDrafts", type: :feature do
  before(:all) do
    @account = FactoryBot.create(:account, admin: true)
    @category = FactoryBot.create(:category)
    @models = ["category"]
  end

  after(:all) do
    Account.destroy_all
    Category.destroy_all
  end

  context "New Category Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/categories/new")
      expect(page).to_not have_xpath("//textarea[@id=\"category_draft_long_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"category_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      Rails.configuration.draftable = false
      visit("/admin/categories/#{@category.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"category_draft_long_description\"]")
    end
  end

  context "Visit Category Administrate Page" do
    let(:new_long_description) { "Don't Panic!" }

    scenario "Change the Category Long Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/categories/#{@category.id}/edit")
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

  context "Create New Category - Make sure drafts didn't break anything" do
    let(:category) { FactoryBot.build(:category) }

    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/categories/new")
      fill_in("Name", with: category.name)
      fill_in("Long description", with: category.long_description)
      click_button("Create Category")
      expect(page).to have_content(category.name)
    end
  end
end
