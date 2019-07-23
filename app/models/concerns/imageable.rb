# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image, dependent: :destroy
  end

  def index_image
    image.variant(image_variation(220, 220)).processed
  end

  def thumb_image
    image.variant(image_variation(120, 120)).processed
  end

  def show_image
    fit_width = 300
    fit_height = 300
    if ((image.blob.metadata[:width] != fit_width) ||
        (image.blob.metadata[:height] != fit_height))
      image.variant(image_variation(fit_width, fit_height)).processed
    else
      image
    end
  end

  def custom_image(width, height)
    image.variant(image_variation(width, height)).processed
  end

  def image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: image.blob, gravity: "Center"))
  end
end
