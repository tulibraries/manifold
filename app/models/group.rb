class Group < ApplicationRecord
	include Validators

	validates :name, :description, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
 	validates :buildings, presence: true
 	validates :spaces, presence: true

  has_many :member
  has_many :persons, through: :member, source: :person

  has_many :building_group
  has_many :buildings, through: :building_group, source: :building

  has_many :space_group
  has_many :spaces, through: :space_group, source: :space

  has_one :chair_dept_head, class_name: "Person", foreign_key: "id"
end
