# frozen_string_literal: true

module Webpages
  class HslPage < ApplicationService
    def call
      {
        resource_links: Category.find_by(slug: "hsl-resources").items,
        research_links: Category.find_by(slug: "hsl-research").items,
        visit_links: Category.find_by(slug: "hsl-study").items,
        event_links: Event.is_current.is_hsl_event.take(5),
        study_room: ExternalLink.find_by(slug: "hsl-study-rooms"),
        remote_learning: Webpage.find_by(slug: "online-support")
      }
    end
  end
end
