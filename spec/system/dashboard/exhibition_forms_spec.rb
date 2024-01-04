# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Exhibition", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @non_admin = FactoryBot.create(:account, admin: false)
    @exhibition = FactoryBot.create(:exhibition)
    @exhibition_with_image = FactoryBot.create(:exhibition, :with_image)
    @models = ["exhibition"]
  end

  after(:all) do
    Account.destroy_all
    Exhibition.destroy_all
  end

  context "New Exhibition Administrate Page" do
    scenario "Create new item as admin" do
      login_as(@admin, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
    scenario "Create new item as non-admin" do
      login_as(@non_admin, scope: :account)
      visit("/admin/exhibitions/new")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
  end

  context "Edit Exhibition Administrate Page" do
    scenario "admin edit" do
      login_as(@admin, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to have_xpath("//*[@id=\"exhibition_title\"]")
    end
    scenario "non-admin edit" do
      login_as(@non_admin, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}/edit")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_slug\"]")
      expect(page).to_not have_xpath("//*[@id=\"exhibition_title\"]")
    end
    scenario "attaches images rather than replace" do
      login_as(@non_admin, scope: :account)
      @exhibition_with_image.images.attach(io:
        File.open(Rails.root.join("spec/fixtures/dream.jpg")),
        filename: "dream.jpg",
        content_type: "image/jpeg")
      @exhibition_with_image.save!
      expect(@exhibition_with_image.images).to have_attributes(size: 2)
    end

  end

end
