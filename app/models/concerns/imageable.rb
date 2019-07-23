# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image, dependent: :destroy
  end

  def index_image
    custom_image(220, 220)
  end

  def thumb_image
    custom_image(120, 120)
  end

  def show_image
    custom_image(300, 300)
  end

  def custom_image(width, height)
    if ((image.blob.metadata[:width] != width) ||
        (image.blob.metadata[:height] != height))
      image.variant(image_variation(width, height)).processed
    else
      image
    end
  end

  def image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: image.blob, gravity: "Center"))
  end
end
