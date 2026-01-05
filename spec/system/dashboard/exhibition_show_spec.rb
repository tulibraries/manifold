# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Exhibition", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, role: "admin")
    @exhibition = FactoryBot.create(:exhibition)
  end

  after(:all) do
    Account.destroy_all
    Exhibition.destroy_all
  end

  context "Exhibition SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/exhibitions/#{@exhibition.id}")
      expect(page).to have_text(@exhibition.label)
    end
  end

end
