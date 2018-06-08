class Group < ApplicationRecord
	include Validators
	
	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	#[FIXME] validates :building_id, presence: true, valid_building_id: true
	#[FIXME] validates :space_id, presence: true, valid_space_id: true
	#[FIXME] validates :persons, presence: true, valid_person: true

  has_many :memberships
  has_many :persons, through: :memberships

  has_and_belongs_to_many :building
  has_and_belongs_to_many :space
end
