# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Attachable
  include Accountable
  include Categorizable
  include Draftable
  include Validators
  extend FriendlyId
  include SchemaDotOrgable

  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert

  validates :title, presence: true
  belongs_to :group, optional: true
  belongs_to :external_link, optional: true

  has_many :external_link_webpages, dependent: nil
  has_many :external_links, through: :external_link_webpages

  accepts_nested_attributes_for :external_link_webpages, allow_destroy: true


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
      description:
    }
  end

  def featured_item
    f = self.external_link_webpages.select { |f| (f.external_link.present? && f.weight == 1) }.sort_by { |f| f.external_link.updated_at }
    f.first if f.present?
  end

  def items
    self.fileabilities.select { |f| (f.file_upload.present? && f.weight > 1) }.sort_by { |f| [f.weight, f.file_upload.name] }
  end

  def online_links
    self.external_link_webpages.select { |f| (f.external_link.present? && f.weight > 1) }.sort_by { |f| [f.weight, f.external_link.title] }
  end

  def reports
    self.online_links + self.items
  end
end
