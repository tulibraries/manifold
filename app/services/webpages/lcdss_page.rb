# frozen_string_literal: true

module Webpages
  class LcdssPage < ApplicationService
    def call
      blog = Blog.find_by(slug: "lcdss-blog")

      {
        webpage: Webpage.find_by(slug: "lcdss-intro"),
        visit_links: Category.find_by(slug: "lcdss-study").items || nil,
        research_links: Category.find_by(slug: "lcdss-research").items || nil,
        event_links: event_links,
        blog: blog,
        blog_posts: blog.blog_posts.sort_by(&:publication_date).reverse.take(5)
      }
    end

    private

      def event_links
        Event.is_current
             .where("lower(tags) LIKE ?", "%digital scholarship%")
             .order(:start_time)
             .take(5)
      end
  end
end
