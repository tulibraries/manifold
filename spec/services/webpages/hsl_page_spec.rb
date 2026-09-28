# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::HslPage do
  describe ".call" do
    let!(:resource_category) do
      FactoryBot.create(:category, slug: "hsl-resources")
    end

    let!(:research_category) do
      FactoryBot.create(:category, slug: "hsl-research")
    end

    let!(:visit_category) do
      FactoryBot.create(:category, slug: "hsl-study")
    end

    let!(:resource_link) do
      FactoryBot.create(:category, name: "HSL Resource Link")
    end

    let!(:research_link) do
      FactoryBot.create(:category, name: "HSL Research Link")
    end

    let!(:visit_link) do
      FactoryBot.create(:category, name: "HSL Visit Link")
    end

    let!(:study_room) do
      FactoryBot.create(
        :external_link,
        slug: "hsl-study-rooms",
        title: "HSL Study Rooms"
      )
    end

    let!(:remote_learning) do
      FactoryBot.create(:webpage, slug: "online-support")
    end

    before do
      Categorization.create!(
        category: resource_category,
        categorizable: resource_link
      )

      Categorization.create!(
        category: research_category,
        categorizable: research_link
      )

      Categorization.create!(
        category: visit_category,
        categorizable: visit_link
      )
    end

    it "returns the HSL page data" do
      result = described_class.call

      expect(result).to include(
        resource_links: [resource_link],
        research_links: [research_link],
        visit_links: [visit_link],
        study_room: study_room,
        remote_learning: remote_learning
      )
    end

    it "returns the first five current HSL events" do
      events = [6, 1, 5, 2, 4, 3].map do |days|
        FactoryBot.create(
          :event,
          title: "HSL Event #{days}",
          tags: "health sciences",
          start_time: days.days.from_now,
          end_time: (days + 1).days.from_now
        )
      end

      FactoryBot.create(
        :event,
        title: "Other Event",
        tags: "other",
        start_time: 1.day.from_now,
        end_time: 2.days.from_now
      )

      FactoryBot.create(
        :event,
        title: "Past HSL Event",
        tags: "health sciences",
        start_time: 2.days.ago,
        end_time: 1.day.ago
      )

      result = described_class.call

      expect(result[:event_links]).to eq(
        [events[1], events[3], events[5], events[4], events[2]]
      )
    end
  end
end
