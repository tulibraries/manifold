class Group < ApplicationRecord
	include Validators

  auto_strip_attributes :email_address  # Auto strip must occur prior to validates

	validates :name, :spaces, :chair_dept_head, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	validates :group_type, presence: true, group_type: true

  has_one_attached :document, dependent: :destroy

  has_many :member
  has_many :persons, through: :member, source: :person

  has_many :space_group
  has_many :spaces, through: :space_group, source: :space

  has_one :group_contact
  has_one :chair_dept_head, through: :group_contact, source: :person
end
