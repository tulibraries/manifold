# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Event", type: :system do

  before(:all) do
    Event.delete_all
    @workshop_event = FactoryBot.create(:event, title: "Gaming Workshop", event_type: "workshop", start_time: 1.day.from_now, end_time: 1.day.from_now)
    @event = FactoryBot.create(:event, title: "History Lecture", event_type: "lecture", start_time: 1.day.from_now, end_time: 1.day.from_now)
    @past_workshop_event = FactoryBot.create(:event, title: "Cooking Workshop", event_type: "workshop", start_time: 2.days.ago, end_time: 2.days.ago)
    @past_event = FactoryBot.create(:event, title: "Science Lecture", event_type: "lecture", start_time: 2.days.ago, end_time: 2.days.ago)
  end

  describe "Events index page" do
    scenario "displays events and workshops together" do
      visit events_path
      expect(page).to_not have_css(".filter-identifier")
      within(".event-filter-link") do
        expect(page).to have_content(I18n.t("manifold.events.index.view_events_link"))
        expect(page).to have_content(I18n.t("manifold.events.index.view_workshops_link"))
      end
      within("#events") do
        expect(page).to have_content(@workshop_event.title)
        expect(page).to have_content(@event.title)
      end
    end
    scenario "events only" do
      visit events_path(type: "events-only")
      within(".event-filter-link") do
        expect(page).to have_content(I18n.t("manifold.events.index.view_workshops_link"))
        expect(page).to have_content(I18n.t("manifold.events.index.view_events_link"))
      end
      within(".filter-identifier") do
        expect(page).to have_content(I18n.t("manifold.events.index.upcoming_events"))
      end
      within("#events") do
        expect(page).to_not have_content(@workshop_event.title)
        expect(page).to have_content(@event.title)
      end
    end
  end

  describe "Past events index page" do
    scenario "displays events and workshops together" do
      visit past_events_path
      expect(page).to_not have_css(".filter-identifier")
      within(".event-filter-link") do
        expect(page).to have_content(I18n.t("manifold.events.index.view_past_events_link"))
        expect(page).to have_content(I18n.t("manifold.events.index.view_past_workshops_link"))
      end
      within("#events") do
        expect(page).to have_content(@past_workshop_event.title)
        expect(page).to have_content(@past_event.title)
        expect(page).to_not have_content(@workshop_event.title)
        expect(page).to_not have_content(@event.title)
      end
      within(".list-label") do
        expect(page).to have_content(I18n.t("manifold.events.index.past_events_label"))
      end
    end
  end

  describe "Events workshops page" do
    scenario "when limited to workshops" do
      visit workshops_path
      expect(page).to have_css(".filter-identifier")
      within(".event-filter-link") do
        expect(page).to have_content(I18n.t("manifold.events.index.view_events_link"))
        expect(page).to have_content(I18n.t("manifold.events.index.view_workshops_link"))
      end
      within("#events") do
        expect(page).to have_content(@workshop_event.title)
        expect(page).to_not have_content(@past_workshop_event.title)
        expect(page).to_not have_content(@past_event.title)
        expect(page).to_not have_content(@event.title)
      end
      within(".filter-identifier") do
        expect(page).to have_content(I18n.t("manifold.events.index.workshops"))
      end
    end
  end

  describe "Past events workshops page" do
    scenario "when limited to workshops" do
      visit past_workshops_path
      expect(page).to have_css(".filter-identifier")
      within(".event-filter-link") do
        expect(page).to have_content(I18n.t("manifold.events.index.view_past_events_link"))
        expect(page).to have_content(I18n.t("manifold.events.index.view_past_workshops_link"))
      end
      within("#events") do
        expect(page).to have_content(@past_workshop_event.title)
        expect(page).to_not have_content(@past_event.title)
        expect(page).to_not have_content(@workshop_event.title)
        expect(page).to_not have_content(@event.title)
      end
      within(".filter-identifier") do
        expect(page).to have_content(I18n.t("manifold.events.headings.past_workshops"))
      end
    end
  end

end
