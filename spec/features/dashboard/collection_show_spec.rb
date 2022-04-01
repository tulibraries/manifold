# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Collection", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @collection = FactoryBot.create(:collection)
  end

  after(:all) do
    Account.destroy_all
    Collection.destroy_all
  end

  context "Collection SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/collections/#{@collection.id}")
      expect(page).to have_text("/collections/#{@collection.id}")
    end
  end

end
