# frozen_string_literal: true

class CategorySerializer < ApplicationSerializer
  include LinkSerializable

  attributes :name, :long_description
end
