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

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert
  has_rich_text :accessibility

  belongs_to :external_link, optional: true
  belongs_to :building
  validates :building_id, presence: true
  validates :name, presence: true

  auto_strip_attributes :email

  has_ancestry

  has_many :groups, dependent: :restrict_with_exception

  def slug_candidates
    [
      :name,
      [:name, :building]
    ]
  end

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

  def label
    name
  end

  def cannot_destroy_message(exception)
    notice = exception.message

    if notice == "Cannot delete record because of dependent groups"
      links = []
      groups.each do |group|
        links << "<a href=/admin/groups/#{slug}/edit>#{group.label}</a>"
      end

      notice = "<p class=text-start>#{label} could not be deleted. "
      notice +=  "They are still attached to the following Groups:<br />"
      notice +=  "Remove and/or replace them there and try again.</p>"

      links.each do |link|
        notice += "<p><strong>#{link}</strong></p>"
      end
      notice += "<br />"
    end

    notice
  end
end
