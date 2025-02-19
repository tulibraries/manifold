# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event", type: :system do

  describe "Events initial page load" do
    scenario "Filter links appear on page" do
      visit(events_path)
      expect(page).to have_content("Limit to workshops")
      expect(page).to have_content("Limit to events")
    end
    scenario "Limit to workshops enabled" do
      visit events_path(type: "Workshop")
      expect(page).to_not have_content("Limit to workshops")
      expect(page).to have_content("Limit to events")
    end
    scenario "Limit to events enabled" do
      visit events_path(type: "is not workshop")
      expect(page).to have_content("Limit to workshops")
      expect(page).to_not have_content("Limit to events")
    end
  end

end
