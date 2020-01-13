# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::CollectionDrafts", type: :feature do
  context "New Collection Administrate Page" do
    scenario "Create new item " do
      account = FactoryBot.create(:account, admin: true)
      login_as(account, scope: :account)
      visit("/admin/collections/new")
      expect(page).to_not have_xpath("//textarea[@id=\"collection_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"collection_draft_access_description\"]")
    end
  end

  context "Visit Collection Administrate Page" do
    before(:each) do
      @account = FactoryBot.create(:account, admin: true)
      @collection = FactoryBot.create(:collection)
      login_as(@account, scope: :account)
      visit("/admin/collections/#{@collection.id}/edit")
    end

    after(:each) do
      @account.destroy
      @collection.destroy
    end

    let(:new_description) { "Don't Panic!" }

    scenario "Change the Collection Description" do
      expect(page).to have_xpath("//div[@id=\"collection_description\"]/text()[contains(., \"#{@collection.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"collection_draft_description\"]/text()[contains(., \"#{@collection.draft_description}\")]")
      find("textarea#collection_draft_description").set(new_description)
      click_button("Update Collection")
      visit("/admin/collections/#{@collection.id}/edit")
      expect(page).to have_xpath("//div[@id=\"collection_description\"]/text()[contains(., \"#{@collection.description}\")]")
      expect(page).to have_xpath("//textarea[@id=\"collection_draft_description\"]/text()[contains(., \"#{new_description}\")]")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Collection")
      visit("/admin/collections/#{@collection.id}/edit")
      expect(page).to_not have_xpath("//div[@id=\"collection_description\"]/text()[contains(., \"#{@collection.description}\")]")
      expect(page).to have_xpath("//div[@id=\"collection_description\"]/text()[contains(., \"#{new_description}\")]")
    end
  end
end
