# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::Service", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, role: "admin")
    @service = FactoryBot.create(:service)
  end

  after(:all) do
    Account.destroy_all
    Service.destroy_all
  end

  context "Service SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/services/#{@service.id}")
      expect(page).to have_text("/services/#{@service.id}")
    end
  end

end
