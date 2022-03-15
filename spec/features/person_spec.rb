# frozen_string_literal: true

require "rails_helper"

RSpec.feature "People", type: :feature do

  describe "index page with pagination" do
    before(:all) do
      Person.delete_all
      Building.delete_all
      21.times do |i|
        FactoryBot.create(:person)
      end
    end

    after(:all) do
      Person.delete_all
      Building.delete_all
    end

    scenario "One full page plus one page with one entry" do
      visit people_path
      expect(page.all(:xpath, "//*[@class='row person']", visible: false).count).to eq(20)
      click_on("Next")
      expect(page.all(:xpath, "//*[@class='row person']", visible: false).count).to eq(1)
    end

  end

  describe "filter by" do
    before(:all) do
      @person1 = FactoryBot.create(:person)
      @person2 = FactoryBot.create(:person)
    end

    after(:all) do
      Person.delete_all
      Building.delete_all
      Group.delete_all
    end

    describe "Location" do
      scenario "Filter person by location" do
        visit("/people")
        within(".staff-index") do
          expect(page).to have_content(@person1.email_address)
          expect(page).to have_content(@person2.email_address)
          within("#locations") do
            click_on(@person1.building.first.name)
          end
          expect(page).to have_content(@person1.email_address)
          expect(page).to_not have_content(@person2.email_address)
        end
      end
    end

    describe "Department" do
      scenario "Filter person by department" do
        @person1.groups = [ FactoryBot.create(:group, group_type: "Department") ]
        @person2.groups = [ FactoryBot.create(:group, group_type: "Department") ]
        visit("/people")
        within(".staff-index") do
          expect(page).to have_content(@person1.email_address)
          expect(page).to have_content(@person2.email_address)
          within("#departments") do
            click_on(@person1.groups.first.name)
          end
          expect(page).to have_content(@person1.email_address)
          expect(page).to_not have_content(@person2.email_address)
        end
      end
    end

    describe "Specialty" do
      scenario "Filter person by specialty" do
        visit("/people")
        within(".staff-index") do
          expect(page).to have_content(@person1.email_address)
          expect(page).to have_content(@person2.email_address)
          within(".filter_subjects") do
            click_on(@person1.specialties.first)
          end
          expect(page).to have_content(@person1.email_address)
          expect(page).to_not have_content(@person2.email_address)
        end
      end
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
        within("#staff-type") do
          click_on("Limit to Subject Librarians Only")
        end
        expect(page).to have_content(@person1.email_address)
        expect(page).to_not have_content(@person2.email_address)
        expect(page).to_not have_content(@person3.email_address)
      end
    end
  end

end
