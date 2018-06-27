class Building < ApplicationRecord
  include Validators

  validates :name, :description, :address1, :temple_building_code, :directions_map, :hours, :image, :campus, :accessibility, presence: true
	validates :email, presence: true, email: true
	validates :phone_number, presence: true, phone_number: true

  has_many :buildings_people, class_name: "BuildingsPeople"
  has_many :persons, through: :buildings_people

  has_many :buildings_groups, class_name: "BuildingsGroups"
  has_many :groups, through: :buildings_groups
end
