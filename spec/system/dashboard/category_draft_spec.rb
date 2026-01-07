# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::CategoryDrafts", type: :system do
  before(:all) do
    @account = FactoryBot.create(:account, role: "admin")
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
      expect(page).to have_xpath("//div[@id=\"category_long_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@category.long_description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"category_draft_long_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"category_draft_long_description_trix_input_category\")]", visible: false).set(new_long_description)
      click_button("Update Category")
      expect(page).to have_content(@category.long_description.body.to_trix_html)
      expect(page).to_not have_content(new_long_description)
      visit("/admin/categories/#{@category.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Category")
      visit("/admin/categories/#{@category.id}/edit")
      expect(page).to_not have_content(@category.long_description.body.to_trix_html)
      expect(page).to have_content(new_long_description)
    end
  end

  context "Create New Category - Make sure drafts didn't break anything" do
    let(:category) { FactoryBot.build(:category) }

    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/categories/new")
      fill_in("Name", with: category.name)
      find(:xpath, "//\*[@id=\"category_long_description_trix_input_category\"]", visible: false).set(category.long_description.body.to_trix_html)
      click_button("Create Category")
      expect(page).to have_content(category.name)
      expect(page).to have_content(category.long_description.body.html_safe)
    end
  end
end
