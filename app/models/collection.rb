# frozen_string_literal: true

class Collection < ApplicationRecord
  has_paper_trail
  include Accountable
  include Categorizable
  include Draftable if Rails.configuration.draftable
  include InputCleaner
  include Imageable
  include SchemaDotOrgable

  validates :name, :description, presence: true

  belongs_to :space
  belongs_to :external_link, optional: true

  has_many :collection_aids, dependent: :destroy
  has_many :finding_aids, through: :collection_aids

  has_draft :description if Rails.configuration.draftable


  serialize :subject

  before_validation :burpArray

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
end
