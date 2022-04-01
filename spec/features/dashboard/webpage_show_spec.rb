# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Webpage", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @webpage = FactoryBot.create(:webpage)
  end

  after(:all) do
    Account.destroy_all
    Webpage.destroy_all
  end

  context "Webpage SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/webpages/#{@webpage.id}")
      expect(page).to have_text("webpages/#{@webpage.id}")
    end
  end

end
