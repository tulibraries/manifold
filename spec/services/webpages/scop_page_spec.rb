# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::ScopPage do
  describe ".call" do
    let!(:webpage) do
      FactoryBot.create(
        :webpage,
        slug: "scop-intro",
        description: ActionText::Content.new("SCOP introduction")
      )
    end

    let!(:pub_services) do
      FactoryBot.create(:category, slug: "publishing-services")
    end

    let!(:scholar_share) do
      FactoryBot.create(:category, slug: "tuscholarshare")
    end

    let!(:pub_service_link) do
      FactoryBot.create(:category, name: "Publishing Service")
    end

    let!(:scholar_share_link) do
      FactoryBot.create(:category, name: "Scholar Share Link")
    end

    let!(:blog) do
      FactoryBot.create(
        :blog,
        title: "Scholarly Communications at Temple",
        slug: "scholarly-communications-at-temple"
      )
    end

    before do
      Categorization.create!(
        category: pub_services,
        categorizable: pub_service_link
      )

      Categorization.create!(
        category: scholar_share,
        categorizable: scholar_share_link
      )
    end

    it "returns the SCOP page data" do
      blog_post = FactoryBot.create(
        :blog_post,
        blog:,
        title: "SCOP Post"
      )

      result = described_class.call

      expect(result).to include(
        webpage: webpage,
        description: webpage.description,
        pub_services: pub_services,
        pub_services_links: [pub_service_link],
        scholar_share: scholar_share,
        scholar_share_links: [scholar_share_link],
        blog: blog
      )

      expect(result[:blog_posts]).to eq([blog_post])
    end

    it "returns the five most recent blog posts by publication date" do
      posts = (1..6).map do |days|
        FactoryBot.create(
          :blog_post,
          blog:,
          title: "SCOP Post #{days}",
          publication_date: days.days.ago
        )
      end

      result = described_class.call

      expect(result[:blog_posts]).to eq(posts.first(5))
    end

    it "returns the first five future SCOP events ordered by start time" do
      events = [6, 1, 5, 2, 4, 3].map do |days|
        FactoryBot.create(
          :event,
          title: "SCOP Event #{days}",
          tags: "SCOP",
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
        title: "Past SCOP Event",
        tags: "SCOP",
        start_time: 2.days.ago,
        end_time: 1.day.ago
      )

      result = described_class.call

      expect(result[:event_links]).to eq(
        [events[1], events[3], events[5], events[4], events[2]]
      )
    end

    it "returns nil optional data when related records are missing" do
      webpage.destroy!
      pub_services.destroy!
      scholar_share.destroy!
      blog.destroy!

      result = described_class.call

      expect(result[:webpage]).to be_nil
      expect(result[:description]).to be_nil
      expect(result[:pub_services]).to be_nil
      expect(result[:pub_services_links]).to be_nil
      expect(result[:scholar_share]).to be_nil
      expect(result[:scholar_share_links]).to be_nil
      expect(result[:blog]).to be_nil
      expect(result[:blog_posts]).to be_nil
    end
  end
end
