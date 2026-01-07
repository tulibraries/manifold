# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Webpage", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, role: "admin")
    @webpage = FactoryBot.create(:webpage)
  end

  after(:all) do
    Account.destroy_all
    Webpage.destroy_all
  end

  context "Webpage SHOW Administrate Page" do
    scenario "Display permalink on existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/webpages/#{@webpage.slug}")
      expect(page).to have_text("webpages/#{@webpage.id}")
    end
  end

end
