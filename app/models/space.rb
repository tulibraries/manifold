# frozen_string_literal: true

class Space < ApplicationRecord
  include Validators
  include InputCleaner
  include HasPolicies
  has_ancestry

  validates :name, presence: true
  validates :description, presence: true

  validates :email, email: true
  validates :phone_number, phone_number: true
  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  has_one_attached :photo, dependent: :destroy

  before_validation :normalize_phone_number

  belongs_to :building

  has_many :occupant
  has_many :persons, -> { order "last_name ASC" }, through: :occupant, source: :person

  has_many :space_group
  has_many :groups, through: :space_group, source: :group

  has_many :service_space
  has_many :related_services, through: :service_space, source: :service

  has_many :policies, as: :policy_makeable

  def self.arrange_as_array(options = {}, hash = nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  def todays_hours
    @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    unless self.hours.blank?
      todays_hours = LibraryHours.where(location_id: self.hours, date: @today).pluck(:hours).first
    else
      todays_hours = self.building.todays_hours
    end
  end
end
