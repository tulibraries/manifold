# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Attachable
  include Accountable
  include Categorizable
  include Draftable
  include StudentAccessible
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
    featured_link = external_link_webpages.find { |item| item.external_link.present? && item.featured? }
    return featured_link if featured_link.present?

    fileabilities.find { |item| item.file_upload.present? && item.featured? }
  end

  def file_items
    fileabilities
      .select { |item| item.file_upload.present? && !item.featured? }
      .sort_by { |item| [item.weight, item.file_upload.name] }
  end

  def online_links
    external_link_webpages
      .select { |item| item.external_link.present? && !item.featured? }
      .sort_by { |item| [item.weight, item.external_link.title] }
  end

  def items
    (online_links + file_items).sort_by do |item|
      name =
        if item.is_a?(ExternalLinkWebpage)
          item.external_link.title
        else
          item.file_upload.name
        end

      [item.weight, name]
    end
  end

  def reports
    items
  end
end
