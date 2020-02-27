# frozen_string_literal: true

module LinkSerializable
  extend ActiveSupport::Concern

  included do
    link :self, Proc.new { |the_object| helpers.url_for(the_object.friendly_id) }
  end
end
