# frozen_string_literal: true

class Building < ApplicationRecord
  require "uploads"

  include Categorizable
  include HasHours
  include HasPolicies
  include InputCleaner
  include SetDates
  include SchemaDotOrgable
  include Validators


  before_validation :normalize_phone_number
  before_validation :sanitize_description
  validates :name, :address1, :address2, :coordinates, :google_id, presence: true
  validates :phone_number, presence: true, phone_number: true
  validates :description, presence: true

  belongs_to :external_link, optional: true
  has_many :spaces, dependent: :destroy
  has_paper_trail

  auto_strip_attributes :email

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
        addressLocality: address2,
        # streetAddress: address,
        # addressLocality: city,
        # addressRegion: state,
        # postalCode: zipcode
      },
      telephone: phone_number,
      email: email,
      geo: coordinates,
      googleId: google_id,
    }
  end
end
