# frozen_string_literal: true

module LinkSerializable
  extend ActiveSupport::Concern

  included do
    link :self, Proc.new { |the_object| helpers.url_for(controller: the_object.model_name.route_key == "people" ? "persons" : the_object.model_name.route_key,
                                                        action: :show,
                                                        id: the_object.to_param) }
  end
end
