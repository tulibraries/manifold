# frozen_string_literal: true

module ImageSerializable
  extend ActiveSupport::Concern

  included do
    attribute :image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.rails_blob_url(the_object.image)
    end

    attribute :thumbnail_image, if: Proc.new { |the_object| the_object.image.attached? } do |the_object|
      helpers.rails_representation_url(the_object.index_image)
    end
  end
end
