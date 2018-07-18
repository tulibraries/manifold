class Building < ApplicationRecord
  include Validators

  validates :name, :description, :address1, :temple_building_code, :directions_map, :hours, :image, :campus, :accessibility, presence: true
	validates :email, presence: true, email: true
	validates :phone_number, presence: true, phone_number: true

  has_many :building_group
  has_many :groups, through: :building_group, source: :group
end
