# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventHelper, type: :helper do
  describe "Get Building Name" do
    context "receives string with translation" do
      it "renders the translation" do
        expect(helper.get_bldg_name("Sullivan Hall")).to include("Sullivan Hall - Blockson Collection")
      end
    end
    context "receives string without translation" do
      it "renders the default" do
        expect(helper.get_bldg_name("Kahn Hall")).to eq("Kahn Hall")
      end
    end
    context "receives nil" do
      it "skips the render which would throw an error" do
        expect(helper.get_bldg_name(nil)).to be nil
      end
    end
  end

  describe "display_date" do
    it "formats input date" do
      expect(helper.display_date("2022-10-26")).to eq("10-26-2022")
    end
  end

  describe "event_location_link" do
    it "links to the associated building's page" do
      building = FactoryBot.create(:building, name: "Charles L. Blockson Afro-American Collection")
      event = FactoryBot.create(:event, building:)

      expect(helper.event_location_link(event)).to include(building_path(building))
    end

    it "does not link to a building when only location_name matches a building name" do
      building = FactoryBot.create(:building, name: "Charles L. Blockson Afro-American Collection")
      event = FactoryBot.create(:event, building: nil, location_name: building.name)

      expect(helper.event_location_link(event)).not_to include(building_path(building))
    end

    it "falls back to google maps when no internal building matches" do
      event = FactoryBot.create(
        :event,
        building: nil,
        location_name: "Off-site building",
        address: "123 Main St",
        city: "Anytown",
        state: "PA",
        zip: "19122"
      )

      expect(helper.event_location_link(event)).to include("google.com/maps/search")
    end
  end

  describe "workshops_link/past_workshops_link" do
    it "returns all workshops link on canned-search pages" do
      expect(helper.workshops_link("dss_events")).to match(t("manifold.events.index.view_all_workshops_link"))
      expect(helper.workshops_link("hsl_events")).to match(t("manifold.events.index.view_all_workshops_link"))
    end
    it "returns workshops link when unaccounted for param supplied" do
      expect(helper.workshops_link()).to match(t("manifold.events.index.view_workshops_link"))
    end
    it "returns workshops link when no param supplied" do
      expect(helper.workshops_link(nil)).to match(t("manifold.events.index.view_workshops_link"))
    end
    it "returns all past workshops link on canned-search pages" do
      expect(helper.past_workshops_link("dss_events")).to match(t("manifold.events.index.view_all_past_workshops_link"))
      expect(helper.past_workshops_link("hsl_events")).to match(t("manifold.events.index.view_all_past_workshops_link"))
    end
  end

  describe "events_link" do
    it "returns all events link on canned-search pages" do
      expect(helper.events_link("dss_events")).to match(t("manifold.events.index.view_all_events_link"))
      expect(helper.events_link("hsl_events")).to match(t("manifold.events.index.view_all_events_link"))
    end
    it "returns events link when unaccounted for param supplied" do
      expect(helper.events_link()).to match(t("manifold.events.index.view_events_link"))
    end
    it "returns events link when no param supplied" do
      expect(helper.events_link(nil)).to match(t("manifold.events.index.view_events_link"))
    end
    it "all past events link on canned-search pages" do
      expect(helper.past_events_link("dss_events")).to match(t("manifold.events.index.view_all_past_events_link"))
      expect(helper.past_events_link("hsl_events")).to match(t("manifold.events.index.view_all_past_events_link"))
    end
  end

  describe "current_link" do
    it "displays past events link when in current events" do
      expect(helper.current_link("search")).to include("past events")
    end
    it "displays current events link when in past events search" do
      expect(helper.current_link("past_search")).to include("current events")
    end
  end

  describe "close_button" do
    it "displays past events link on past template" do
      expect(helper.close_button("past_events")).to include(past_events_path)
    end
    it "displays past events link on past search template" do
      expect(helper.close_button("past_workshops")).to include(past_events_path)
    end
    it "displays past events link on past search template" do
      expect(helper.close_button("past_search")).to include(past_events_path)
    end
    it "displays current events title on current template" do
      expect(helper.close_button("index")).to include(events_path)
      expect(helper.close_button("events")).to include(events_path)
      expect(helper.close_button("workshops")).to include(events_path)
      expect(helper.close_button("search")).to include(events_path)
    end
  end

  describe "set_header" do
    it "displays dsc heading" do
      expect(helper.set_header("dss_events", nil)).to include(t("manifold.events.headings.dsc"))
    end
    it "displays hsl heading" do
      expect(helper.set_header("hsl_events", nil)).to include(t("manifold.events.headings.hsl"))
    end
    it "displays current events heading" do
      expect(helper.set_header("index", nil)).to include(t("manifold.events.headings.upcoming_events_workshops"))
    end
    it "displays current events heading" do
      expect(helper.set_header("index", "events-only")).to include(t("manifold.events.headings.upcoming_events"))
    end
    it "displays current workshops heading" do
      expect(helper.set_header("workshops", nil)).to include(t("manifold.events.headings.upcoming_workshops"))
    end
    it "displays past events heading" do
      expect(helper.set_header("past_events", nil)).to include(t("manifold.events.headings.past_events_workshops"))
    end
    it "displays past events heading" do
      expect(helper.set_header("past_events", "events-only")).to include(t("manifold.events.headings.past_events"))
    end
    it "displays past workshops heading" do
      expect(helper.set_header("past_workshops", nil)).to include(t("manifold.events.headings.past_workshops"))
    end
  end

  describe "filters_link" do
    it "displays current event/workshop links on current page" do
      expect(helper.filters_link("index")).to include(t("manifold.events.index.view_workshops_link"))
      expect(helper.filters_link("index")).to include(t("manifold.events.index.view_events_link"))
    end
    it "displays past event/workshop links on past page" do
      expect(helper.filters_link("past")).to include(t("manifold.events.index.view_past_workshops_link"))
      expect(helper.filters_link("past")).to include(t("manifold.events.index.view_past_events_link"))
    end
  end

  describe "render_event_image" do
    it "uses the feed-supplied alt text on an attached image" do
      event = FactoryBot.create(:event, :with_image, alt_text: "A descriptive caption")
      expect(helper.render_event_image(event)).to include('alt="A descriptive caption"')
    end

    it "falls back to a title-based alt when an attached image has no feed alt text" do
      event = FactoryBot.create(:event, :with_image, title: "Poetry Reading", alt_text: nil)
      expect(helper.render_event_image(event)).to include('alt="Event image for Poetry Reading"')
    end

    it "renders the Temple T placeholder with a descriptive alt when no image is attached" do
      event = FactoryBot.create(:event, alt_text: "Ignored without an image")
      html = helper.render_event_image(event)
      expect(html).to match(%r{assets/T})
      expect(html).to include('alt="Temple T Logo"')
    end

    context "index variant" do
      it "links the attached image to the event and carries the alt text" do
        event = FactoryBot.create(:event, :with_image, alt_text: "Thumbnail caption")
        html = helper.render_event_image(event, variant: :index)
        expect(html).to include('alt="Thumbnail caption"')
        expect(html).to include(%Q(href="#{event_path(event.id)}"))
      end

      it "falls back to the Temple T placeholder when no image is attached" do
        event = FactoryBot.create(:event)
        html = helper.render_event_image(event, variant: :index)
        expect(html).to match(%r{assets/T})
        expect(html).to include('alt="Temple T Logo"')
      end
    end
  end
end
