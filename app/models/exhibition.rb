# frozen_string_literal: true

class Exhibition < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable
  include SchemaDotOrgable

  belongs_to :group, optional: true
  belongs_to :space, optional: true
  belongs_to :collection, optional: true

  before_save :sanitize_description

  def label
    title
  end

  def schema_dot_org_type
    "ExhibitionEvent"
  end

  def additional_schema_dot_org_attributes
    {
      startDate: start_time,
      endDate: end_time,
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
