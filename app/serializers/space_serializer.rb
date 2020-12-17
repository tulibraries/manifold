# frozen_string_literal: true

class SpaceSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  set_type :space

  attributes :name, :hours, :accessibility, :phone_number, :email
end
