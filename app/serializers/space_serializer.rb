# frozen_string_literal: true

class SpaceSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :name, :description, :hours, :accessibility, :phone_number, :email
end
