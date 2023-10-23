# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    title { "Devopsing" }
    base_url { "https://sites.temple.edu/devopsing" }
    last_sync_date { "2018-09-24 11:32:13" }

    factory :blog_with_public_status do
      public_status { true }
    end

    factory :blog_with_feed_path do
      feed_path { "/weird-feed" }
    end

    factory :blog_bad_url do
      base_url { "not://a:url" }
    end

    factory :blog_iteration do
      sequence(:title) { |n| "Gritty does Devopsing #{n}" }
      sequence(:feed_path) { |n| "files/blog_posts#{n}.rss" }
    end

    factory :blog_fixture do
      feed_path { "files/blog_posts.rss" }
    end
  end
end
