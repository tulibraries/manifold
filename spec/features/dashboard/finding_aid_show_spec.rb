# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::FindingAid", type: :feature do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @finding_aid = FactoryBot.create(:finding_aid)
  end

  after(:all) do
    Account.destroy_all
    FindingAid.destroy_all
  end

  context "FindingAid SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/finding_aids/#{@finding_aid.id}")
      expect(page).to have_text("/finding_aids/#{@finding_aid.id}")
    end
  end

end
