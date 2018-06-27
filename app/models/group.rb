class Group < ApplicationRecord
	include Validators
	
	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true

  has_many :memberships
  has_many :persons, through: :memberships

  has_many :buildings_groups, class_name: "BuildingsGroups"
  has_many :buildings, through: :buildings_groups

  has_and_belongs_to_many :space
end
