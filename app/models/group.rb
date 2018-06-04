class Group < ApplicationRecord
	include Validators
	
	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	validates :building_id, presence: true, presence: true, valid_building_id: true
	validates :space_id, presence: true, valid_space_id: true
	validates :person_id, presence: true, valid_person_id: true

  has_and_belongs_to_many :person
  belongs_to :space
  belongs_to :building
end
