# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  FEATURED_IMAGE_WIDTH = 420
  FEATURED_IMAGE_HEIGHT = 270

  included do
    has_one_attached :image, dependent: :destroy
    validates :image, content_type: { in: ["image/png", "image/jpeg", "image/gif"],
                                      message: I18n.t("manifold.error.content_type_invalid_image") },
                      size: { less_than: I18n.t("manifold.default.image_file_size_limit").kilobyte ,
                              message: I18n.t("manifold.error.file_size_out_of_range_image") }
  end

  def thumb_image
    custom_image(160, 220)
  end

  def index_image()
    custom_image(250, 350)
  end

  def profile_image
    custom_image(240, 240)
  end

  def show_image()
    custom_image(421, 271)
  end

  def featured_image()
    padded_image(FEATURED_IMAGE_WIDTH, FEATURED_IMAGE_HEIGHT)
  end

  def custom_image(width, height)
    ensure_image_analyzed

    return image if image_matches_dimensions?(width, height)

    image.variant(format: :png,
                  background: :transparent,
                  gravity: crop_gravity,
                  resize_to_fill: [width, height])
  end

  private

    def padded_image(width, height)
      ensure_image_analyzed

      return image if image_matches_dimensions?(width, height)

      image.variant(format: :png,
                    background: "#F7F7F7",
                    gravity: "Center",
                    resize_to_fit: [width, height],
                    extent: "#{width}x#{height}")
    end

    def ensure_image_analyzed
      image.analyze unless image.analyzed?
    end

    def image_matches_dimensions?(width, height)
      image_width = image.metadata[:width].presence || 240
      image_height = image.metadata[:height].presence || 240

      image_width == width && image_height == height
    end

    def crop_gravity
      image_width = image.metadata[:width].presence || 240
      image_height = image.metadata[:height].presence || 240

      image_width > image_height ? "North" : "Center"
    end
end
