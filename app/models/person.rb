class Person < ApplicationRecord
  include Validators

  validates :first_name, :last_name, :chat_handle, :job_title, :identifier, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	#[FIXME] validates :building_id, presence: true, valid_building_id: true
	#[FIXME] validates :space_id, valid_space_id: true
	#[FIXME] validates :groups, valid_group: true

  has_many :memberships
  has_many :groups, through: :memberships

  has_many :buildings_people, class_name: "BuildingsPeople"
  has_many :buildings, through: :buildings_people

  has_many :spaces_people, class_name: "SpacesPeople"
  has_many :spaces, through: :spaces_people
end
