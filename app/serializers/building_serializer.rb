# frozen_string_literal: true

class BuildingSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  set_type :building

  attributes :name, :address1, :city, :state, :zipcode, :coordinates, :google_id, :phone_number

  has_many :spaces
end
