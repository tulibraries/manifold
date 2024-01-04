# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Event", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @event = FactoryBot.create(:event)
  end

  after(:all) do
    Account.destroy_all
    Event.destroy_all
  end

  context "Event SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/events/#{@event.id}")
      expect(page).to have_text("/events/#{@event.id}")
    end
  end

end
