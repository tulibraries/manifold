# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Dashboard::Group", type: :system do
  before(:all) do
    @admin = FactoryBot.create(:account, admin: true)
    @group = FactoryBot.create(:group)
  end

  after(:all) do
    Account.destroy_all
    # Group.destroy_all
  end

  context "Group SHOW Administrate Page" do
    scenario "Display existing item show page" do
      login_as(@admin, scope: :account)

      visit("/admin/groups/#{@group.id}")
      expect(page).to have_text("/groups/#{@group.id}")
    end
  end

end
