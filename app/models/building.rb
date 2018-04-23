class Building < ApplicationRecord
  validates :name, :description, :address1, :temple_building_code, :directions_map, :hours, :phone_number, :image, :campus, :accessibility, :email, presence: true
end
