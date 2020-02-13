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
  include SchemaDotOrgable
  has_ancestry

  validates :name, presence: true
  validates :description, presence: true

  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  before_validation :normalize_phone_number

  belongs_to :building
  belongs_to :external_link, optional: true

  has_many :occupant, dependent: :destroy
  has_many :persons, -> { order "last_name ASC" }, through: :occupant, source: :person

  has_many :space_group, dependent: :destroy
  has_many :groups, through: :space_group, source: :group

  def schema_dot_org_type
    "Place"
  end

  def additional_schema_dot_org_attributes
    {
      telephone: phone_number,
      containedInPlace: {
        "@type" => "containedInPlace",
        name: building.name,
        address: {
          "@type" => "PostalAddress",
          streetAddress: building.address1,
          addressLocality: building.address2
        }
      }
    }
  end

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
