# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Person", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @person = FactoryBot.create(:person)
  end

  after(:all) do
    Account.destroy_all
    Person.destroy_all
  end

  context "Person SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/people/#{@person.id}")
      expect(page).to have_text("/people/#{@person.id}")
    end
  end

end
