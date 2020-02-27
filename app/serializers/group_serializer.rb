# frozen_string_literal: true

class GroupSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :name, :description, :group_type, :external
end
