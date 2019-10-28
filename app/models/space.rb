# frozen_string_literal: true

class Space < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include HasHours
  include HasPolicies
  include Imageable
  include InputCleaner
  include SetDates
  include Validators
  has_ancestry
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates_uniqueness_of :slug

  validates :name, presence: true
  validates :description, presence: true

  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  before_validation :normalize_phone_number

  belongs_to :building
  belongs_to :external_link, optional: true

  has_many :occupant
  has_many :persons, -> { order "last_name ASC" }, through: :occupant, source: :person

  has_many :space_group
  has_many :groups, through: :space_group, source: :group

  has_many :service_space
  has_many :related_services, through: :service_space, source: :service

  def self.arrange_as_array(options = {}, hash = nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end
end
