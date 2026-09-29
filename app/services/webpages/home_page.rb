# frozen_string_literal: true

module Webpages
  class HomePage < ApplicationService
    def call
      exhibition = Exhibition.is_current.find_by(highlighted: true)
      featured_events = Event.is_current.is_displayable.where(featured: true)

      {
        todays_hours: todays_hours,
        highlights: Highlight.with_image.where(promoted: true),
        featured_events: [exhibition, *featured_events].compact,
        digcols: Highlight.with_image.for_digital_collections,
        cta3: Category.find_by(slug: "computers-printing-technology"),
        cta4: Category.find_by(slug: "explore-charles")
      }
    end

    private

      def todays_hours
        file_path = Rails.root.join("public/cache/todays_hours")
        File.exist?(file_path) ? File.read(file_path) : nil
      end
  end
end
