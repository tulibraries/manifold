# frozen_string_literal: true

class Building < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include HasPolicies
  include SetDates
  include Categorizable
  include Imageable
  include HasHours
  require "uploads"

  validates :name, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, presence: true
  validates :phone_number, presence: true, phone_number: true
  validates :description, presence: true

  has_many :library_hours
  has_many :spaces
  belongs_to :external_link, optional: true

  auto_strip_attributes :email

  before_validation :normalize_phone_number
  before_validation :sanitize_description

  def to_ld
    building_hash = {}
    building_hash["@type"] = "Building"
    building_hash["name"] = name
    building_hash["description"] = ActionController::Base.helpers.strip_tags(description)

    building_hash["location"] = {}
    building_hash["location"]["@type"] = "Place"
    building_hash["location"]["address"] = {}
    building_hash["location"]["address"]["@type"] = "PostalAddress"
    building_hash["location"]["address"]["streetAddress"] = address1
    building_hash["location"]["address"]["addressLocality"] = address2[0..-10]
    building_hash["location"]["address"]["addressRegion"] = address2[-9..-7]
    building_hash["location"]["address"]["postalCode"] = address2[-5..-1]

    building_hash
  end
end
