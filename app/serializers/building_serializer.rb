# frozen_string_literal: true

class BuildingSerializer < ApplicationSerializer
  include ImageSerializable
  include LinkSerializable

  set_type :building

  attributes :name, :description, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number

  has_many :spaces
end
