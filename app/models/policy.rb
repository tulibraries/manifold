# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include Draftable
  include InputCleaner
  include Validators
  include SchemaDotOrgable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert

  validates :name, presence: true
  serialize :category

  def slug_candidates
    [
      :name,
      [:name, :category],
      [:name, :category, :id]
    ]
  end

  def label
    name
  end

  def schema_dot_org_type
    "WebPage"
  end

  def additional_schema_dot_org_attributes
    {
      name:,
      description:
    }
  end
end
