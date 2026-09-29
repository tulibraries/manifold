# frozen_string_literal: true

module Webpages
  class ScrcPage < ApplicationService
    def call
      {
        visit_links: Category.find_by(slug: "scrc-study").items,
        collection_links: Category.find_by(slug: "scrc-collections").items,
        webpage: Webpage.find_by(slug: "scrc"),
        intro: Snippet.find_by(slug: "scrc-homepage-intro")
      }
    end
  end
end
