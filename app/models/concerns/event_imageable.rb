# frozen_string_literal: true

# Derivatives for the events section (events and exhibitions), whose
# featured images display at a 5:3 aspect ratio. Images are padded rather
# than cropped, so nothing is lost from the original. Including models keep
# Imageable's other derivatives (fit_image, custom_image) unchanged.
module EventImageable
  extend ActiveSupport::Concern
  include Imageable

  EVENT_ASPECT_RATIO = 3.0 / 5
  EVENT_IMAGE_WIDTH = 420
  EVENT_IMAGE_HEIGHT = 252

  def thumb_image
    event_image(160)
  end

  def index_image
    event_image(250)
  end

  def featured_image
    event_image(180)
  end

  def show_image
    event_image(EVENT_IMAGE_WIDTH, EVENT_IMAGE_HEIGHT)
  end

  private

    def event_image(width, height = (width * EVENT_ASPECT_RATIO).round)
      padded_image(width, height, background: :transparent)
    end
end
