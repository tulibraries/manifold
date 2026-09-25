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

      expect(result[:blogs]).to contain_exactly(*blogs)
    end

    it "returns the three most recently created blog posts" do
      blog = FactoryBot.create(:blog)

      posts = (1..4).map do |index|
        FactoryBot.create(
          :blog_post,
          blog:,
          title: "News Post #{index}",
          created_at: index.days.ago
        )
      end

      result = described_class.call

      expect(result[:blogposts]).to eq(
        [posts[0], posts[1], posts[2]]
      )
    end

    it "returns up to three promoted highlights with images" do
      included = (1..4).map do
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

      expect(result[:highlights]).to eq(included.first(3))
    end
  end
end
