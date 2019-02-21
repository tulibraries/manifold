# frozen_string_literal: true

class BuildingSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |building| helpers.url_for(building) }

  attributes :name, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number, :description
  attribute :photo, if: Proc.new { |building| building.photo.attached? } do |building|
    helpers.rails_blob_url(building.photo)
  end

  attribute :thumbnail_photo, if: Proc.new { |building| building.photo.attached? } do |building|
    helpers.rails_representation_url(building.photo.variant(resize: "100x100").processed)
  end

  has_many :spaces
end
