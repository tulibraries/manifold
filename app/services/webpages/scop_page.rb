# frozen_string_literal: true

module Webpages
  class ScopPage < ApplicationService
    def call
      webpage = Webpage.find_by(slug: "scop-intro")
      pub_services = Category.find_by(slug: "publishing-services")
      scholar_share = Category.find_by(slug: "tuscholarshare")
      blog = Blog.find_by(slug: "scholarly-communications-at-temple")

      {
        webpage: webpage,
        description: webpage&.description,
        pub_services: pub_services,
        pub_services_links: pub_services&.items,
        scholar_share: scholar_share,
        scholar_share_links: scholar_share&.items,
        event_links: event_links,
        blog: blog,
        blog_posts: blog_posts(blog)
      }
    end

    private

      def event_links
        Event.where(tags: "SCOP")
             .where(end_time: Time.zone.now..Float::INFINITY)
             .order(:start_time)
             .take(5)
      end

      def blog_posts(blog)
        return if blog.blank?

        blog.blog_posts.sort_by(&:publication_date).reverse.take(5)
      end
  end
end
