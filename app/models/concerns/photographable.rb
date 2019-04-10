# frozen_string_literal: true

module Photographable
  extend ActiveSupport::Concern

  def index_image
    image.variant(image_variation(220, 220)).processed
  end

  def thumb_image
    image.variant(image_variation(120, 120)).processed
  end

  def show_image
    image.variant(image_variation(300, 300)).processed
  end

  def image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: image.blob, gravity: "Center"))
  end
end
