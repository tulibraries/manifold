# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::LcdssPage do
  describe ".call" do
    let!(:webpage) do
      FactoryBot.create(:webpage, slug: "lcdss-intro")
    end

    let!(:visit_category) do
      FactoryBot.create(:category, slug: "lcdss-study")
    end

    let!(:research_category) do
      FactoryBot.create(:category, slug: "lcdss-research")
    end

    let!(:visit_link) do
      FactoryBot.create(:category, name: "LCDSS Visit Link")
    end

    let!(:research_link) do
      FactoryBot.create(:category, name: "LCDSS Research Link")
    end

    let!(:blog) do
      FactoryBot.create(:blog, title: "LCDSS Blog")
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
    end

    it "returns the LCDSS page data" do
      blog_post = FactoryBot.create(
        :blog_post,
        blog:,
        title: "LCDSS Post"
      )

      result = described_class.call

      expect(result).to include(
        webpage: webpage,
        visit_links: [visit_link],
        research_links: [research_link],
        blog: blog
      )
      expect(result[:blog_posts]).to eq([blog_post])
    end

    it "returns the five most recent blog posts by publication date" do
      posts = (1..6).map do |days|
        FactoryBot.create(
          :blog_post,
          blog:,
          title: "LCDSS Post #{days}",
          publication_date: days.days.ago
        )
      end

      result = described_class.call

      expect(result[:blog_posts]).to eq(posts.first(5))
    end

    it "returns the first five current digital scholarship events ordered by start time" do
      events = [6, 1, 5, 2, 4, 3].map do |days|
        FactoryBot.create(
          :event,
          title: "LCDSS Event #{days}",
          tags: "digital scholarship",
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

      result = described_class.call

      expect(result[:event_links]).to eq(
        [events[1], events[3], events[5], events[4], events[2]]
      )
    end
  end
end
