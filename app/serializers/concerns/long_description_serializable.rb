# frozen_string_literal: true

module LongDescriptionSerializable
  extend ActiveSupport::Concern
  included do
    attribute :long_description do |the_object|
      the_object.long_description.body.to_html
    end
  end
end
