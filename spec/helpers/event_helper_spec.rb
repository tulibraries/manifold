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

  describe "workshops_link" do
    it "returns workshops link when limiter not active" do
      expect(helper.workshops_link(nil)).to match("Limit to workshops")
    end
    it "returns nothing when limiter active" do
      expect(helper.workshops_link("workshop")).to_not be
    end
    it "returns all workshops link on search page" do
      expect(helper.workshops_link("dss_events")).to match("View all workshops")
    end
  end

  describe "events_link" do
    it "returns events link when limiter not active" do
      expect(helper.events_link(nil)).to match("Limit to events")
    end
    it "returns nothing when limiter active" do
      expect(helper.events_link("event")).to_not be
    end
    it "returns all events link on search page" do
      expect(helper.events_link("dss_events")).to match("View all events")
    end
  end

  describe "current_link" do
    it "displays current events link when in past events" do
      expect(helper.current_link("search")).to include("past-events")
      expect(helper.current_link("search")).to_not include("current-events")
    end
    it "displays current events link when in past events search" do
      expect(helper.current_link("past_search")).to include("current-events")
      expect(helper.current_link("past_search")).to_not include("past-events")
    end
  end

  describe "events_title" do
    it "displays past events title on past template" do
      expect(helper.events_title("past")).to include("Past")
    end
    it "displays past events title on past search template" do
      expect(helper.events_title("past_search")).to include("Past")
    end
    it "displays current events title on past template" do
      expect(helper.events_title("")).to include("Events, Exhibits & Workshops")
      expect(helper.events_title("")).to_not include("Past")
    end
    it "displays current events title on past template" do
      expect(helper.events_title("search")).to include("Events, Exhibits & Workshops")
      expect(helper.events_title("")).to_not include("Past")
    end
  end

  describe "close_button" do
    it "displays past events link on past template" do
      expect(helper.close_button("past")).to include(past_events_path)
    end
    it "displays past events link on past search template" do
      expect(helper.close_button("past_search")).to include(past_events_path)
    end
    it "displays current events title on current template" do
      expect(helper.close_button("index")).to include(events_path)
      expect(helper.close_button("search")).to include(events_path)
    end
  end

  describe "set_heading" do
    it "displays dsc heading" do
      expect(helper.set_header("dss_events")).to include(t("manifold.events.headings.dsc"))
    end
    it "displays hsl heading" do
      expect(helper.set_header("hsl_events")).to include(t("manifold.events.headings.hsl"))
    end
    it "displays past events heading" do
      expect(helper.set_header("index")).to include(t("manifold.events.headings.upcoming_events"))
    end
    it "displays current events heading" do
      expect(helper.set_header("past")).to include(t("manifold.events.headings.past_events"))
    end
  end
end
