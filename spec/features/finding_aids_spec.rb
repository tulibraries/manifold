# frozen_string_literal: true

require "rails_helper"

RSpec.feature "FindingAids", type: :feature do
  context "Finding Aids Home Page" do
    before(:all) do
      @account = FactoryBot.create(:account, admin: true)
      @collection_1 = FactoryBot.create(:collection, name: "Collection 1")
      @collection_2 = FactoryBot.create(:collection, name: "Collection 2")
      @collection_3 = FactoryBot.create(:collection, name: "Collection 3")
      @finding_aid_1 = FactoryBot.create(:finding_aid, name: "Finding Aid 1",
                                         subject: ["subject 1"],
                                         collections: [@collection_1])
      @finding_aid_2 = FactoryBot.create(:finding_aid, name: "Finding Aid 2",
                                         subject: ["subject 2"],
                                         collections: [@collection_2])
      @finding_aid_1a = FactoryBot.create(:finding_aid, name: "Finding Aid 1a",
                                          subject: ["subject 1"],
                                          collections: [@collection_3])
      @finding_aid_4 = FactoryBot.create(:finding_aid, name: "First Finding Aid 1 and Done",
                                          subject: ["subject 1"],
                                          collections: [@collection_1])
    end

    after(:all) do
      Collection.delete_all
      FindingAid.delete_all
    end

    context "Collecting Area" do
      scenario "Visit finding aid that has a collection" do
        visit("/finding_aids")
        within(".aid-index") do
          within(".filter_collections") do
            expect(page).to have_content(@collection_1.name)
            expect(page).to have_content(@collection_2.name)
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to have_content(@finding_aid_2.name)
      end

      scenario "Filter by Collection" do
        visit("/finding_aids")
        within(".aid-index") do
          within(".filter_collections") do
            click_on @collection_1.name
            expect(page).to have_content(@collection_1.name)
            expect(page).to_not have_content(@collection_2.name)
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to_not have_content(@finding_aid_2.name)
      end
    end

    context "Subject Area" do
      scenario "Visit finding aid that has an subject" do
        visit("/finding_aids")
        within(".aid-index") do
          within(".filter_subjects") do
            expect(page).to have_content(@finding_aid_1.subject.first)
            expect(page).to have_content(@finding_aid_2.subject.first)
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to have_content(@finding_aid_2.name)
      end

      scenario "Filter by Subject" do
        visit("/finding_aids")
        within(".aid-index") do
          within(".filter_subjects") do
            click_on @finding_aid_1.subject.first
            expect(page).to have_content(@finding_aid_1.subject.first)
            expect(page).to_not have_content(@finding_aid_2.subject.first)
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to_not have_content(@finding_aid_2.name)
      end
    end

    context "Collecting and Subject Area" do
      scenario "Filter by Collection, then by Subject" do
        visit("/finding_aids")
        within(".aid-index") do
          within(".filter_subjects") do
            click_on @finding_aid_1.subject.first
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to_not have_content(@finding_aid_2.name)
        expect(page).to have_content(@finding_aid_1a.name)
        within(".aid-index") do
          within(".filter_collections") do
            click_on @collection_1.name
          end
        end
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to_not have_content(@finding_aid_2.name)
        expect(page).to_not have_content(@finding_aid_1a.name)
      end
    end

    context "search results" do
      scenario "search term found" do
        visit("/finding_aids?search=1a")
        expect(page).to have_content(@finding_aid_1a.name)
        expect(page).to_not have_content(@finding_aid_2.name)
      end
      scenario "ordered search results" do
        visit(finding_aids_path(search: @finding_aid_4.name))
        expect(page).to have_content(@finding_aid_1.name)
        expect(page).to have_content(@finding_aid_4.name)
        expect(@finding_aid_4.name).to appear_before(@finding_aid_1.name, only_text: true)
      end
    end
  end

end
