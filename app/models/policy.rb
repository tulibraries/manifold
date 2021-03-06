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

  has_draft :description

  validates :name, :description, :effective_date, presence: true
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
      name: name,
      description: description
    }
  end
end
