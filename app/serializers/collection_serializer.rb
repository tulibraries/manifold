# frozen_string_literal: true

class CollectionSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :name, :description, :subject, :contents, :add_to_footer
end
