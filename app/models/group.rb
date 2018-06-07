class Group < ApplicationRecord
	include Validators
	
	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	validates :building_id, presence: true, presence: true, valid_building_id: true
	validates :space_id, presence: true, valid_space_id: true

  has_many :memberships
  has_many :persons, through: :memberships

  belongs_to :space
  belongs_to :building
end
