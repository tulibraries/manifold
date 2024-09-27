# frozen_string_literal: true

class Exhibition < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Draftable
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  belongs_to :group, optional: true
  belongs_to :space, optional: true
  belongs_to :collection, optional: true

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert

  validates :start_date, :end_date, presence: true

  scope :is_past, -> { where("end_date < ?", Date.current) }
  scope :is_current, -> { where("end_date >= ?", Date.current) }

  has_many_attached :images

  validates :images, content_type: ["image/png", "image/jpeg", "image/gif"],
                      size: { less_than: 3.megabytes , message: "is too large" }


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
      location: space.present? ? {
        "@type" => "Place",
        name: space.label,
        address: {
          "@type" => "PostalAddress",
          streetAddress: space.building.address1,
          addressLocality: space.building.address2
        }
      } : nil
    }
  end
end
