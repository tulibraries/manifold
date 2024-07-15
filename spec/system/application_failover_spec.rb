# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ApplicationFailover", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @failover = FactoryBot.create(:application_failover)
    @cta3 = FactoryBot.create(:category, slug: "computers-printing-technology")
    @cta4 = FactoryBot.create(:category, slug: "explore-charles")
  end

  after(:all) do
    Account.destroy_all
    ApplicationFailover.destroy_all
  end

  context "librarysearch experiencing outage" do
    scenario "correctly redirects homepage form action to Primo" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      check("application_failover[turn_on]")
      expect(page).to have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("todays_hours") do
        visit(root_path)
      end

      expect(find("form#failover-desktop-search-form")["action"]).to_not match(I18n.t("manifold.default.search_url"))
      expect(find("form#failover-desktop-search-form")["action"]).to match(I18n.t("manifold.default.alternate_search_url"))
    end
    scenario "correctly redirects global form action to Primo" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      check("application_failover[turn_on]")
      expect(page).to have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("hours") do
        visit(hours_path)
      end

      expect(find("form#failover-global-search")["action"]).to_not match(I18n.t("manifold.default.search_url"))
      expect(find("form#failover-global-search")["action"]).to match(I18n.t("manifold.default.alternate_search_url"))
    end
    scenario "correctly redirects mobile global form action to Primo" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      check("application_failover[turn_on]")
      expect(page).to have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("hours") do
        visit(hours_path)
      end

      expect(find("form#failover-global-mobile-search-form")["action"]).to_not match(I18n.t("manifold.default.search_url"))
      expect(find("form#failover-global-mobile-search-form")["action"]).to match(I18n.t("manifold.default.alternate_search_url"))
    end
  end

  context "librarysearch restored" do
    scenario "correctly redirects homepage form action to librarysearch" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      expect(page).to_not have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("hours_today") do
        visit(root_path)
      end

      expect(find("form#desktop-search-form")["action"]).to match(I18n.t("manifold.default.search_url"))
      expect(find("form#desktop-search-form")["action"]).to_not match(I18n.t("manifold.default.alternate_search_url"))
    end
    scenario "correctly redirects global form action to librarysearch" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      expect(page).to_not have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("hours") do
        visit(hours_path)
      end

      expect(find("form#global-search")["action"]).to match(I18n.t("manifold.default.search_url"))
      expect(find("form#global-search")["action"]).to_not match(I18n.t("manifold.default.alternate_search_url"))
    end
    scenario "correctly redirects mobile global form action to librarysearch" do
      login_as(@admin, scope: :account)
      visit("/admin/application_failovers/#{@failover.id}/edit")
      expect(page).to_not have_checked_field("application_failover[turn_on]")
      click_button("Update Application failover")

      VCR.use_cassette("hours") do
        visit(hours_path)
      end

      expect(find("form#mobile-search-form")["action"]).to match(I18n.t("manifold.default.search_url"))
      expect(find("form#mobile-search-form")["action"]).to_not match(I18n.t("manifold.default.alternate_search_url"))
    end
  end

end
