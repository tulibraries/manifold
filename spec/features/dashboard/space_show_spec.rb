# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Service", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @space = FactoryBot.create(:space)
  end

  after(:all) do
    Account.destroy_all
    Group.destroy_all
    Space.destroy_all
  end

  context "Space SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/spaces/#{@space.id}")
      expect(page).to have_text("/spaces/#{@space.id}")
    end
  end

end
