# frozen_string_literal: true

module Webpages
  class BlocksonPage < ApplicationService
    def call
      tours = Category.find_by(name: "360&deg; Virtual Exhibits")

      {
        webpage: Webpage.find_by(slug: "blockson-intro"),
        visit_links: Category.find_by(slug: "blockson-study").items,
        research_links: Category.find_by(slug: "blockson-research").items,
        events: events,
        tours: tours,
        tour_links: tours&.items
      }
    end

    private

      def events
        Event.where(["tags LIKE ? and end_time >= ?", "blockson", Time.zone.now])
             .order(:start_time)
             .take(4)
      end
  end
end
