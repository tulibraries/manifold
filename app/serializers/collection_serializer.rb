# frozen_string_literal: true

class CollectionSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :name, :subject, :contents
end
