# frozen_string_literal: true

class Group < ApplicationRecord
  has_paper_trail
  include Attachable
  include Validators
  include InputCleaner
  include HasPolicies
  include SetDates
  include Categorizable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :name, :chair_dept_heads, presence: true
  validates :group_type, presence: true, group_type: true

  before_validation :sanitize_description

  has_many :webpages, dependent: :destroy

  belongs_to :parent_group, optional: true, class_name: "Group"
  has_many :child_groups, class_name: "Group", foreign_key: "parent_group_id", dependent: :destroy, inverse_of: false

  has_many :member, dependent: :destroy
  has_many :persons, -> { order "last_name ASC" }, through: :member, source: :person, inverse_of: false

  has_one :space_group, dependent: :destroy
  has_one :space, through: :space_group, source: :space

  has_many :group_contact, dependent: :destroy
  has_many :chair_dept_heads, through: :group_contact, source: :person

  has_many :service_group, dependent: :destroy
  has_many :related_services, through: :service_group, source: :service

  scope :is_department, -> { where("group_type = ?", "Department") }

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end

  def get_chair
    members = Array.new
    chair = persons.select { |p| chair_dept_heads.include?(p) }
    persons.to_a.each do |p|
      members << p
    end
    chair.sort_by { |p| p.last_name }.reverse.each do |q|
      members.unshift(q)
    end
    members.uniq
  end

  def todays_hours
    unless space.nil?
      space.todays_hours
    end
  end
  def label
    name
  end
end
