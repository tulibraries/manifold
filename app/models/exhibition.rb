# frozen_string_literal: true

class Exhibition < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable
  include Draftable
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  belongs_to :group, optional: true
  belongs_to :space, optional: true
  belongs_to :collection, optional: true

  has_draft :title, :description

  before_save :sanitize_description

  validates :start_date, :end_date, presence: true

  def slug_candidates
    [
      :title,
      [:title, :start_date]
    ]
  end

  def label
    title
  end

  def schema_dot_org_type
    "ExhibitionEvent"
  end

  def additional_schema_dot_org_attributes
    {
      startDate: start_date,
      endDate: end_date,
      location: {
        "@type" => "Place",
        name: space.label,
        address: {
          "@type" => "PostalAddress",
          streetAddress: space.building.address1,
          addressLocality: space.building.address2
        }
      }
    }
  end
end
