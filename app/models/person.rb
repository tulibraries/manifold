class Person < ApplicationRecord
  include Validators

  validates :first_name, :last_name, :chat_handle, :job_title, :identifier, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true

  has_many :memberships
  has_many :groups, through: :memberships

  has_many :buildings_people, class_name: "BuildingsPeople"
  has_many :buildings, through: :buildings_people

  has_many :spaces_people, class_name: "SpacesPeople"
  has_many :spaces, through: :spaces_people
end
