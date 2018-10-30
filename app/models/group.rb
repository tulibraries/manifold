# frozen_string_literal: true

class Group < ApplicationRecord
  include Validators
  include InputCleaner

  validates :name, :chair_dept_heads, presence: true
  validates :group_type, presence: true, group_type: true

  before_validation :sanitize_description

  has_many_attached :documents, dependent: :destroy

  has_many :member
  has_many :persons, -> { order "last_name ASC" }, through: :member, source: :person

  has_one :space_group
  has_one :space, through: :space_group, source: :space

  has_many :group_contact
  has_many :chair_dept_heads, through: :group_contact, source: :person

  has_many :service_group
  has_many :related_services, through: :service_group, source: :service

  has_many :group_policy
  has_many :policies, through: :group_policy
end
