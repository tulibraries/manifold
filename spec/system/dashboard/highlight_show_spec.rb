# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Highlight", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @highlight = FactoryBot.create(:highlight)
  end

  after(:all) do
    Account.destroy_all
    Highlight.destroy_all
  end

  context "Highlight SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)
      visit("/admin/highlights/#{@highlight.id}")
      expect(page).to have_text("/highlights/#{@highlight.id}")
    end
  end

end
