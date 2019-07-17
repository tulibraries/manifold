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
    image.variant(image_variation(300, 300)).processed
  end

  def custom_image(width, height)
    image.variant(image_variation(width, height)).processed
  end

  def image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: image.blob, gravity: "Center"))
  end
end
