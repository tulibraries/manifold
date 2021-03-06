# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Policy", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @policy = FactoryBot.create(:policy)
  end

  after(:all) do
    Account.destroy_all
    Policy.destroy_all
  end

  context "Policy SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/policies/#{@policy.id}")
      expect(page).to have_text("library.temple.edu/policies/#{@policy.id}")
    end
  end

end
