# frozen_string_literal: true

class CategorySerializer < ApplicationSerializer
  include LinkSerializable
  include LongDescriptionSerializable

  attributes :name, :description
end
