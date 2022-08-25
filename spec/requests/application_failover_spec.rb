# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ApplicationFailover", type: :request do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @failover = FactoryBot.create(:application_failover)
  end

  after(:all) do
    Account.destroy_all
    ApplicationFailover.destroy_all
  end

  context "homepage in failover state" do
    scenario "correctly redirects form action to Primo" do
      login_as(@admin, scope: :account)      
      visit("/admin/application_failovers/#{@failover.id}/edit")
      check("turn_on")
      expect(page).to have_checked_field("turn_on")
      click_button("Update Application failover")
      visit(root_path)
      expect(page).to_not have_css("form#desktop-search-form", text: librarysearch_url("everything"))
      expect(page).to have_css("form#desktop-search-form", text: t("manifold.default.alternate_search_url"))
    end
  end

end
