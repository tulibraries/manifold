class Group < ApplicationRecord
	include Validators

	validates :name, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
 	validates :spaces, presence: true
	validates :chair_dept_head, presence: true

	auto_strip_attributes :email_address

  has_many :member
  has_many :persons, through: :member, source: :person

  has_many :space_group
  has_many :spaces, through: :space_group, source: :space

  has_one :group_contact
  has_one :chair_dept_head, through: :group_contact, source: :person
end
