# frozen_string_literal: true

module Webpages
  class NewsPage < ApplicationService
    def call
      {
        blogs: Blog.all,
        blogposts: BlogPost.all.order(:created_at).reverse.take(3),
        highlights: Highlight.with_image.where(promoted: true).take(3)
      }
    end
  end
end
