# frozen_string_literal: true

module DescriptionSerializable
  extend ActiveSupport::Concern
  included do
    attribute :description do |the_object|
      the_object.description.body if the_object.description.present?
    end
  end
end
