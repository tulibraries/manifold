class Group < ApplicationRecord
	include Validators
	
	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true

  has_many :group_person
  has_many :persons, through: :group_person

  has_many :building_group
  has_many :buildings, through: :building_group

  has_many :space_group
  has_many :spaces, through: :space_group
end
