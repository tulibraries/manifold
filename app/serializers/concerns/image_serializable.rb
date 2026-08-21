# frozen_string_literal: true

module ImageSerializable
  extend ActiveSupport::Concern

  included do
    attribute :image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.polymorphic_path(the_object.show_image)
    end

    attribute :thumbnail_image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.polymorphic_path(the_object.thumb_image)
    end
  end
end
