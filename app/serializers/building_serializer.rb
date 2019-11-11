# frozen_string_literal: true

class BuildingSerializer < ApplicationSerializer
  include LinkSerializable

  set_type :building

  attributes :name, :description, :address1, :address2, :coordinates, :google_id, :phone_number

  has_many :spaces
end
