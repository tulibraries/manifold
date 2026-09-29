# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::NewsPage do
  describe ".call" do
    it "returns all blogs" do
      blogs = [
        FactoryBot.create(:blog, title: "Blog One"),
        FactoryBot.create(:blog, title: "Blog Two")
      ]

      result = described_class.call

      expect(result[:blogs]).to include(*blogs)
    end

    it "returns the three most recently created blog posts" do
      blog = FactoryBot.create(:blog)
      base_time = Time.current + 1.hour

      posts = (1..4).map do |index|
        FactoryBot.create(
          :blog_post,
          blog:,
          title: "News Post #{index}",
          created_at: base_time + index.seconds
        )
      end

      result = described_class.call

      expect(result[:blogposts]).to eq(
        [posts[3], posts[2], posts[1]]
      )
    end

    it "returns up to three promoted highlights with images" do
      (1..4).each do
        FactoryBot.create(
          :highlight,
          :with_image,
          promoted: true
        )
      end

      FactoryBot.create(
        :highlight,
        promoted: true
      )

      FactoryBot.create(
        :highlight,
        :with_image,
        promoted: false
      )

      result = described_class.call

      expect(result[:highlights].size).to be <= 3
      expect(result[:highlights]).to all(
        satisfy { |highlight| highlight.promoted? && highlight.image.attached? }
      )
    end
  end
end
