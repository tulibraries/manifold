# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::BlocksonPage do
  describe ".call" do
    let!(:webpage) do
      FactoryBot.create(:webpage, slug: "blockson-intro")
    end

    let!(:visit_category) do
      FactoryBot.create(:category, slug: "blockson-study")
    end

    let!(:research_category) do
      FactoryBot.create(:category, slug: "blockson-research")
    end

    let!(:visit_link) do
      FactoryBot.create(:category, name: "Blockson Visit Link")
    end

    let!(:research_link) do
      FactoryBot.create(:category, name: "Blockson Research Link")
    end

    let!(:tours) do
      FactoryBot.create(:category, name: "360&deg; Virtual Exhibits")
    end

    let!(:tour_link) do
      FactoryBot.create(:category, name: "Blockson Tour Link")
    end

    before do
      Categorization.create!(
        category: visit_category,
        categorizable: visit_link
      )

      Categorization.create!(
        category: research_category,
        categorizable: research_link
      )

      Categorization.create!(
        category: tours,
        categorizable: tour_link
      )
    end

    it "returns the Blockson page data" do
      result = described_class.call

      expect(result).to include(
        webpage: webpage,
        visit_links: [visit_link],
        research_links: [research_link],
        tours: tours,
        tour_links: [tour_link]
      )
    end

    it "returns the first four current Blockson events ordered by start time" do
      events = [5, 1, 4, 2, 3].map do |days|
        event = FactoryBot.create(
          :event,
          title: "Blockson Event #{days}",
          tags: "other",
          start_time: days.days.from_now,
          end_time: (days + 1).days.from_now
        )

        set_raw_tags(event, "blockson")
        event
      end

      FactoryBot.create(
        :event,
        title: "Other Event",
        tags: "other",
        start_time: 1.day.from_now,
        end_time: 2.days.from_now
      )

      past_event = FactoryBot.create(
        :event,
        title: "Past Blockson Event",
        tags: "other",
        start_time: 2.days.ago,
        end_time: 1.day.ago
      )

      set_raw_tags(past_event, "blockson")

      result = described_class.call

      expect(result[:events]).to eq(
        [events[1], events[3], events[4], events[2]]
      )
    end

    it "returns nil tour links when the tours category is missing" do
      tours.destroy!

      result = described_class.call

      expect(result[:tours]).to be_nil
      expect(result[:tour_links]).to be_nil
    end

    def set_raw_tags(event, value)
      Event.connection.exec_update(
        "UPDATE events SET tags = $1 WHERE id = $2",
        "Set raw event tags",
        [
          ActiveRecord::Relation::QueryAttribute.new(
            "tags",
            value,
            ActiveRecord::Type::String.new
          ),
          ActiveRecord::Relation::QueryAttribute.new(
            "id",
            event.id,
            ActiveRecord::Type::Integer.new
          )
        ]
      )
    end
  end
end
