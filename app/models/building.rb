class Building < ApplicationRecord
  include Validators
  include InputCleaner

  validates :name, :description, :address1, :temple_building_code, :directions_map, :hours, :image, :campus, presence: true
	#validates :email, presence: true, email: true
	validates :phone_number, presence: true, phone_number: true

  auto_strip_attributes :email, :phone_number

  before_validation :normalize_phone_number
end
