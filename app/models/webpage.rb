# frozen_string_literal: true

class Webpage < ApplicationRecord
  require "carrierwave/orm/activerecord"
  include Accountable
  include Attachable
  include Categorizable
  include Draftable
  include SetDates
  include Validators
  extend FriendlyId
  include SchemaDotOrgable
  mount_uploader :epub, EpubUploader

  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :description
  has_rich_text :draft_description
  # validates_presence_of :description # required rich text fields throw error in administrate if blank
  has_rich_text :covid_alert

  validates :title, presence: true
  belongs_to :group, optional: true
  belongs_to :external_link, optional: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
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
