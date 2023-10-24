# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Category", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @category = FactoryBot.create(:category)
  end

  after(:all) do
    Account.destroy_all
    Category.destroy_all
  end

  context "Category SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/categories/#{@category.id}")
      expect(page).to have_text("/categories/#{@category.id}")
    end
  end

end
