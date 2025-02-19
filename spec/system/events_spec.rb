# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event", type: :system do
  before (:all) do
    workshop_event = FactoryBot.create(:event,
      title: "Workshop", event_type: "Workshop",
      start_time: Time.current + 7.hours, end_time: Time.current+25.hours)
    non_workshop_event = FactoryBot.create(:event,
      title: "Lecture", event_type: "Lecture",
      start_time: Time.current + 7.hours, end_time: Time.current+25.hours)
  end

  describe "Events index page" do
    scenario "Filter links appear on page" do
      visit(events_path)
      save_and_open_page
      expect(page).to have_content("Limit to workshops")
      expect(page).to have_content("Limit to events")
    end
    scenario "Limit to workshops enabled" do
      visit events_path(type: "Workshop")
      save_and_open_page
      expect(page).to_not have_content("Limit to workshops")
      expect(page).to have_content("Limit to events")
    end
    scenario "Limit to events enabled" do
      visit events_path(type: "is not workshop")
      save_and_open_page
      expect(page).to have_content("Limit to workshops")
      expect(page).to_not have_content("Limit to events")
    end
  end

end
