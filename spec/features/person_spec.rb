# frozen_string_literal: true

require "rails_helper"

RSpec.feature "People", type: :feature do

  describe "Specialist" do
    before(:all) do
      @person1 = FactoryBot.create(:person, :with_subjects)
      @person2 = FactoryBot.create(:person)
    end

    after(:all) do
      Person.delete_all
    end

    scenario "Filter specialists" do
      visit("/people")
      within(".staff-index") do
        expect(page).to have_content(@person1.email_address)
        expect(page).to have_content(@person2.email_address)
      end

      visit("/people?specialists=true")
      within(".staff-index") do
        expect(page).to have_content(@person1.email_address)
        expect(page).to_not have_content(@person2.email_address)
      end
    end
  end

end
