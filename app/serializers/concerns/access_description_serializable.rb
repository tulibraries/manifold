# frozen_string_literal: true

module AccessDescriptionSerializable
  extend ActiveSupport::Concern
  included do
    attribute :access_description do |the_object|
      the_object.access_description.body if the_object.access_description.present?
    end
  end
end
