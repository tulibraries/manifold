# frozen_string_literal: true

class Space < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include Draftable
  include HasHours
  include HasPolicies
  include Imageable
  include InputCleaner
  include SetDates
  include Validators
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged
  validates :slug, presence: true

  validates :name, presence: true
  validates :description, presence: true

  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  before_validation :normalize_phone_number

  belongs_to :building
  belongs_to :external_link, optional: true

  has_ancestry

  has_many :occupant, dependent: :destroy
  has_many :persons, -> { order "last_name ASC" }, through: :occupant, source: :person

  has_many :space_group, dependent: :destroy
  has_many :groups, through: :space_group, source: :group

  def slug_candidates
    [
      :name,
      [:name, :building]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  has_draft :description

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
