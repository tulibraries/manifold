# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

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
    custom_image(271, 421)
  end

  def custom_image(width, height)
    image.analyze unless image.analyzed

    image_width = (image.metadata[:width].presence || 240)
    image_height = image.metadata[:height].present? ? image.metadata[:width] : 240

    if (image_width != width) || (image_height != height)
      if image_width > image_height
        image.variant(format: :png,
                      background: :transparent,
                      gravity: "North",
                      resize_to_fit: [width, height])
      else
        image.variant(format: :png,
                      background: :transparent,
                      gravity: :center,
                      resize_to_fill: [width, height])
      end
    else
      image
    end
  end
end
