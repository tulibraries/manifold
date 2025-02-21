# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event", type: :system do
  before (:all) do
    workshop_event = FactoryBot.create(:event,
      title: "Gaming Workshop", event_type: "workshop",
      start_time: Time.current + 7.hours, end_time: Time.current + 25.hours)
    non_workshop_event = FactoryBot.create(:event,
      title: "History Lecture", event_type: "lecture",
      start_time: Time.current + 7.hours, end_time: Time.current + 25.hours)
  end

  describe "Events index page" do
    scenario "Filter links appear on page" do
      visit(events_path)
      within(".event-filter-link") do
        expect(page).to have_content("View Events")
        expect(page).to have_content("View Workshops")
      end
      expect(page).to_not have_css(".workshops-label")
      within("#current-events") do
        expect(page).to have_content("Gaming Workshop")
        expect(page).to have_content("History Lecture")
      end
    end
    scenario "Limit to workshops enabled" do
      visit events_path(type: "workshop")
      within(".event-filter-link") do
        expect(page).to have_content("View Events")
        expect(page).to_not have_content("View Workshops")
      end
      within(".workshops-label") do
        expect(page).to have_content("Workshops")
        expect(page).to_not have_content("View Events")
      end
      within("#current-events") do
        expect(page).to have_content("Gaming Workshop")
        expect(page).to_not have_content("History Lecture")
      end
    end
    scenario "Non-Workshop Events enabled" do
      visit events_path(type: "events-only")
      within(".event-filter-link") do
        expect(page).to have_content("View Workshops")
        expect(page).to_not have_content("View Events")
      end
      within(".workshops-label") do
        expect(page).to have_content("View Events")
      end
      within("#current-events") do
        expect(page).to_not have_content("Gaming Workshop")
        expect(page).to have_content("History Lecture")
      end
    end
  end

end
