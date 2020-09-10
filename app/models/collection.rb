# frozen_string_literal: true

class Collection < ApplicationRecord
  has_paper_trail
  include Accountable
  include Categorizable
  include Draftable
  include InputCleaner
  include Imageable
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :name, :description, presence: true

  belongs_to :space
  belongs_to :external_link, optional: true

  has_many :collection_aids, dependent: :destroy
  has_many :finding_aids, through: :collection_aids

  has_draft :description


  serialize :subject

  before_validation :burpArray

  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end

  def schema_dot_org_type
    "ArchiveComponent"
  end

  def additional_schema_dot_org_attributes
    {
      about: subject.map(&:inspect).join(", "),
      itemLocation: {
        "@type" => "Place",
        name: space.building.name,
        address: {
          "@type" => "PostalAddress",
          streetAddress: space.building.address1,
          addressLocality: space.building.address2
        }
      }
    }
  end

  def label
    name
  end
end
