# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Collection", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, role: "admin")
    @non_admin = FactoryBot.create(:account, role: "regular")
    @collection = FactoryBot.create(:collection)
    @models = ["collection"]
  end

  after(:all) do
    Account.destroy_all
    Collection.destroy_all
  end

  context "New Collection Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/collections/new")
      expect(page).to have_xpath("//*[@id=\"collection_slug\"]")
      expect(page).to have_xpath("//*[@id=\"collection_name\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/collections/new")
      expect(page).to_not have_xpath("//*[@id=\"collection_slug\"]")
      expect(page).to have_xpath("//*[@id=\"collection_name\"]")
    end
  end

  context "Edit Collection Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/collections/#{@collection.id}/edit")
      expect(page).to have_xpath("//*[@id=\"collection_slug\"]")
      expect(page).to have_xpath("//*[@id=\"collection_name\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/collections/#{@collection.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"collection_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"collection_name\"]")
    end
  end

end
