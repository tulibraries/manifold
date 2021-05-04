# frozen_string_literal: true

class GroupSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :name, :group_type, :external
end
