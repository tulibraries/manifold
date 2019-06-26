# frozen_string_literal: true

class BuildingSerializer < ApplicationSerializer
  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |building| helpers.url_for(building) }

  set_type :building

  attributes :name, :description, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number

  include ImageSerializable

  has_many :spaces
end
