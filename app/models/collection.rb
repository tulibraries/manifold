# frozen_string_literal: true

class Collection < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable

  validates :name, :description, presence: true

  belongs_to :space
  belongs_to :external_link, optional: true

  has_many :collection_aids
  has_many :finding_aids, through: :collection_aids

  serialize :subject

  before_validation :burpArray

  def to_ld

    collection_hash = {}
    collection_hash["@type"] = "Building"
    collection_hash["name"] = name
    collection_hash["description"] = ActionController::Base.helpers.strip_tags(description)

    collection_hash["location"] = {}
    collection_hash["location"]["@type"] = "Place"
    collection_hash["location"]["address"] = {}
    collection_hash["location"]["address"]["@type"] = "PostalAddress"

    locality = space.building.locality
    collection_hash["location"]["address"]["streetAddress"] = space.building.street_address
    collection_hash["location"]["address"]["addressLocality"] = locality[:city]
    collection_hash["location"]["address"]["addressRegion"] = locality[:state]
    collection_hash["location"]["address"]["postalCode"] = locality[:zip]

    collection_hash["telephone"] = space.building.phone_number
    collection_hash["email"] = space.building.email
    collection_hash["image"] = Rails.application.routes.url_helpers.rails_representation_url(show_image) if image.attached?
    collection_hash["containedInPlace"] = space.building.campus
    collection_hash["geo"] = space.building.coordinates
    collection_hash["googleId"] = space.building.google_id
    collection_hash
  end
end
