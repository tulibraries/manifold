# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "ServiceDrafts", type: :feature do
  context "Visit Service Administrate Page" do
    before(:all) do
      @account = FactoryBot.create(:account, admin: true)
      @service = FactoryBot.create(:service)
      login_as(@account, :scope => :account)
    end
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Service Description" do
      visit("/admin/services/#{@service.id}/edit")
      within("textarea#service_description") do
        expect(page).to have_text @service.description
      end
      within("textarea#service_draft_description") do
        expect(page).to have_text @service.draft_description
      end
      find("textarea#service_draft_description").set(new_description)
      click_button ("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("textarea#service_description") do
        expect(page).to have_text @service.description
      end
      within("textarea#service_draft_description") do
        expect(page).to have_text new_description
      end
      check("Apply Draft")
      click_button("Update Service")
      visit("/admin/services/#{@service.id}/edit")
      within("textarea#service_description") do
        expect(page).to_not have_text @service.description
        expect(page).to have_text new_description
      end
    end
  end
end
