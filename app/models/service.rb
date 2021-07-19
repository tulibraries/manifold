# frozen_string_literal: true

class Service < ApplicationRecord
  has_paper_trail
  include Accountable
  include Categorizable
  include Draftable
  include InputCleaner
  include HasPolicies
  include SetDates
  include SchemaDotOrgable

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :title, :intended_audience, presence: true

  serialize :intended_audience

  belongs_to :external_link, optional: true

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :access_description
  has_rich_text :draft_access_description
  has_rich_text :covid_alert

  before_validation :remove_empty_audience

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def remove_empty_audience
    # Rails tends to return an empty string in multi-selects array
    intended_audience&.reject! { |a| a.empty? }
  end

  def label
    title
  end

  def schema_dot_org_type
    "WebPage"
  end

  def additional_schema_dot_org_attributes
    {
      name: title,
      description: description
    }
  end
end
