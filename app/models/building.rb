# frozen_string_literal: true

class Building < ApplicationRecord
  include Categorizable
  include Draftable
  include HasHours
  include HasPolicies
  include InputCleaner
  include SetDates
  include SchemaDotOrgable
  include Validators
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :name, :address1, :city, :state, :zipcode, :coordinates, :google_id, presence: true
  validates :phone_number, presence: true

  belongs_to :external_link, optional: true
  has_many :spaces, dependent: :destroy
  has_paper_trail

  has_many :occupant, dependent: :destroy
  has_many :persons, -> { order "last_name ASC" }, through: :occupant, source: :person

  auto_strip_attributes :email

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end

  def street_address
    address1
  end

  def schema_dot_org_type
    "Building"
  end

  def additional_schema_dot_org_attributes
    {
      address: {
        "@type" => "https://schema.org/PostalAddress",
        streetAddress: address1,
        addressLocality: city,
        addressRegion: state,
        postalCode: zipcode
      },
      telephone: phone_number,
      email:,
      geo: coordinates,
      googleId: google_id,
    }
  end

  def label
    name
  end
end
