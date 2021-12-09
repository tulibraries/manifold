# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  require Rails.root.join("lib/uploads.rb")

  included do
    has_one_attached :image, dependent: :destroy
    validates :image, content_type: { in: ["image/png", "image/jpg", "image/jpeg", "image/gif"],
                                      message: I18n.t("manifold.error.content_type_invalid_image") },
                      size: { less_than: I18n.t("manifold.default.image_file_size_limit").kilobyte ,
                              message: I18n.t("manifold.error.file_size_out_of_range_image") }
  end

  def index_image
    custom_image(I18n.t("manifold.default.index_image_size"), I18n.t("manifold.default.index_image_size"))
  end

  def index_image_path
    entity_image_path("medium")
  end

  def index_image_url
    entity_image_url("medium")
  end

  def thumb_image
    custom_image(I18n.t("manifold.default.index_image_size"), I18n.t("manifold.default.index_image_size"))
  end

  def thumb_image_path
    entity_image_path("thumbnail")
  end

  def thumb_image_url
    entity_image_url("thumbnail")
  end

  def show_image
    custom_image(I18n.t("manifold.default.index_image_size"), I18n.t("manifold.default.index_image_size"))
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
    image.blob.analyze

    # binding.pry if image.blob.metadata[:width].nil?

    if image.blob.metadata[:width] > image.blob.metadata[:height]
      ActiveStorage::Variation.new(Uploads.resize_x_and_pad(width: width, height: height, blob: image.blob))
    else
      # ActiveStorage::Variation.new(Uploads.resize_to_fit(width: width, height: height, blob: self.send(image_field.to_sym).blob))
      ActiveStorage::Variation.new(Uploads.resize_to_fit(width: width, height: height, blob: image.blob))
    end if image.present?
  end

  def entity_image_path(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_image_#{type}_path", to_param)
  end

  def entity_image_url(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_image_#{type}_url", to_param)
  end
end
