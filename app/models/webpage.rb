# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Accountable
  include Attachable
  include Categorizable
  include Draftable
  include SetDates
  include Validators
  extend FriendlyId
  include SchemaDotOrgable
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_draft :description

  validates :title, :description, presence: true
  belongs_to :group, optional: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
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
