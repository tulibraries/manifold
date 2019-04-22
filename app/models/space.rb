# frozen_string_literal: true

class Space < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include HasPolicies
  include SetDates
  include Categorizable
  include Imageable
  has_ancestry

  validates :name, presence: true
  validates :description, presence: true

  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  before_validation :normalize_phone_number

  belongs_to :building

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
