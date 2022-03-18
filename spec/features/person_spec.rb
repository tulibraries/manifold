# frozen_string_literal: true

require "rails_helper"

RSpec.feature "People", type: :feature do

  describe "index page with pagination" do
    before(:all) do
      Person.delete_all
      Space.delete_all
      21.times do |i|
        FactoryBot.create(:person)
      end
    end

    after(:all) do
      Person.delete_all
      Space.delete_all
    end

    scenario "One full page plus one page with one entry" do
      visit people_path
      expect(page.all(:xpath, "//*[@class='row person']", visible: false).count).to eq(20)
      click_on("Next")
      expect(page.all(:xpath, "//*[@class='row person']", visible: false).count).to eq(1)
    end

  end

  describe "Specialist" do
    before(:all) do
      @person1 = FactoryBot.create(:person)
      @person2 = FactoryBot.create(:person, specialties: [])
      @person3 = FactoryBot.create(:person, specialties: nil)
    end

    after(:all) do
      Person.delete_all
    end

    scenario "Filter specialists" do
      visit("/people")
      within(".staff-index") do
        expect(page).to have_content(@person1.email_address)
        expect(page).to have_content(@person2.email_address)
        expect(page).to have_content(@person3.email_address)
      end

      visit("/people?specialists=true")
      within(".staff-index") do
        expect(page).to have_content(@person1.email_address)
        expect(page).to_not have_content(@person2.email_address)
        expect(page).to_not have_content(@person3.email_address)
      end
    end
  end

end
