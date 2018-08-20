class Building < ApplicationRecord
  include Validators
  include InputCleaner

  validates :name, :address1, :temple_building_code, :directions_map, :hours, :campus, presence: true
	validates :email, presence: true, email: true
	validates :phone_number, presence: true, phone_number: true
  # TODO implement: validates :description, presence: true

	has_one_attached :photo, dependent: :destroy

  auto_strip_attributes :email

  before_validation :normalize_phone_number

end
