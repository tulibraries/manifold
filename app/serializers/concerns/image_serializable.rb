# frozen_string_literal: true

module ImageSerializable
  extend ActiveSupport::Concern

  included do
    attribute :image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.send("#{the_object.class.to_s.underscore}_image_large_url", the_object.to_param)
    end

    attribute :thumbnail_image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.send("#{the_object.class.to_s.underscore}_image_thumbnail_url", the_object.to_param)
    end
  end
end
