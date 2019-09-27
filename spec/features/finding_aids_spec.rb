require 'rails_helper'

RSpec.feature "FindingAids", type: :feature do
  context "Finding Aids Home Page" do

    scenario "Should be click on the a search all finding aids button" do
      visit("/finding_aids")
      expect(page).to have_content("Search All Finding Aids")
    end

  end

  context "Collecting Area" do
    Capybara.ignore_hidden_elements = false
    before(:all) do
      @collection = FactoryBot.create(:collection)
      @other_collection = FactoryBot.create(:collection, name: "Other Collection")
      @finding_aid = FactoryBot.create(:finding_aid, name:"Finding Aid 1", collections: [@collection])
      @other_finding_aid = FactoryBot.create(:finding_aid, name:"Finding Aid 2", collections: [@other_collection])
    end

    after(:all) do
      Collection.delete_all
      FindingAid.delete_all
    end

    scenario "Visit finding aid that has an collection" do
      visit("/finding_aids")
      within(".aid-index") do
        within(".filter_collections") do
          expect(page).to have_content(@collection.name)
          expect(page).to have_content(@other_collection.name)
        end
      end
      expect(page).to have_content(@finding_aid.name)
      expect(page).to have_content(@other_finding_aid.name)
    end

    scenario "Filter by Collection" do
      visit("/finding_aids")
      within(".aid-index") do
        within(".filter_collections") do
          click_on @collection.name
          expect(page).to have_content(@collection.name)
          expect(page).to_not have_content(@other_collection.name)
        end
      end
      expect(page).to have_content(@finding_aid.name)
      expect(page).to_not have_content(@other_finding_aid.name)
    end
  end

  context "Subject Area" do
    Capybara.ignore_hidden_elements = false
    before(:all) do
      @finding_aid = FactoryBot.create(:finding_aid, name: "Finding Aid 1")
      @other_finding_aid = FactoryBot.create(:finding_aid, name: "Finding Aid 2", subject: ["other_subject"])
    end

    after(:all) do
      FindingAid.delete_all
    end

    scenario "Visit finding aid that has an subject" do
      visit("/finding_aids")
      within(".aid-index") do
        within(".filter_subjects") do
          expect(page).to have_content(@finding_aid.subject.first)
          expect(page).to have_content(@other_finding_aid.subject.first)
        end
      end
      expect(page).to have_content(@finding_aid.name)
      expect(page).to have_content(@other_finding_aid.name)
    end

    scenario "Filter by Subject" do
      visit("/finding_aids")
      within(".aid-index") do
        within(".filter_subjects") do
          click_on @finding_aid.subject.first
          expect(page).to have_content(@finding_aid.subject.first)
          expect(page).to_not have_content(@other_finding_aid.subject.first)
        end
      end
      expect(page).to have_content(@finding_aid.name)
      expect(page).to_not have_content(@other_finding_aid.name)
    end
  end
end
