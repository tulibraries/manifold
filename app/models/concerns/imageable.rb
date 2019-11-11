# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image, dependent: :destroy
  end

  def index_image
    custom_image(220, 220)
  end

  def index_image_path
    entity_image_path("medium")
  end

  def index_image_url
    entity_image_url("medium")
  end

  def thumb_image
    custom_image(120, 120)
  end

  def thumb_image_path
    entity_image_path("thumbnail")
  end

  def thumb_image_url
    entity_image_url("thumbnail")
  end

  def show_image
    custom_image(300, 300)
  end

  def show_image_path
    entity_image_path("large")
  end

  def show_image_url
    entity_image_url("large")
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

  def entity_image_path(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_image_#{type}_path", id)
  end

  def entity_image_url(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_image_#{type}_url", id)
  end
end
