# frozen_string_literal: true

class BuildingSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |building| helpers.url_for(building) }

  set_type :building

  attributes :name, :description, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number, :label
  attributes :updated_at

  attribute :image, if: Proc.new { |building| building.image.attached? } do |building|
    helpers.rails_blob_url(building.image)
  end

  attribute :thumbnail_image, if: Proc.new { |building| building.image.attached? } do |building|
    helpers.rails_representation_url(building.index_image)
  end

  has_many :spaces
end
