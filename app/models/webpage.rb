# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Accountable
  include Categorizable
  include SetDates
  include Validators
  extend FriendlyId
  include SchemaDotOrgable
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged
  validates :slug, presence: true

  has_one_attached :document, dependent: :destroy
  # validates :document, content_type: ["application/pdf"]
  validates :title, :description, presence: true

  belongs_to :group, optional: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed? || super
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
