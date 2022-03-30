# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Exhibition", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
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
      expect(page).to have_text("/exhibitions/#{@exhibition.id}")
    end
  end

end
