# frozen_string_literal: true

class Group < ApplicationRecord
  include Validators
  include InputCleaner

  auto_strip_attributes :email_address  # Auto strip must occur prior to validates

  validates :name, :chair_dept_heads, presence: true
  validates :email_address, presence: true, email: true
  validates :phone_number, presence: true, phone_number: true
  validates :group_type, presence: true, group_type: true

  before_validation :sanitize_description

  has_many_attached :documents, dependent: :destroy

  has_many :member
  has_many :persons, -> { order "last_name ASC" }, through: :member, source: :person

  has_one :space_group
  has_one :spaces, through: :space_group, source: :space

  has_many :group_contact
  has_many :chair_dept_heads, through: :group_contact, source: :person

  has_many :service_group
  has_many :related_services, through: :service_group, source: :service

  def get_chair
    chair = persons.find(chair_dept_head.id)
    persons.to_a.unshift(chair).uniq
  end
  def todays_hours
    unless spaces.nil?
      todays_hours = spaces.todays_hours
    end
  end
end
