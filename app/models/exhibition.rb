# frozen_string_literal: true

class Exhibition < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Draftable
  include SchemaDotOrgable
  extend FriendlyId
  include EventImageable

  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  belongs_to :group, optional: true
  belongs_to :space, optional: true
  belongs_to :collection, optional: true

  has_rich_text :description
  has_rich_text :draft_description
  has_rich_text :covid_alert

  validates :start_date, :end_date, presence: true
  validate :only_one_highlighted_exhibition, if: :highlighted?

  scope :is_past, -> { where("end_date < ?", Date.current) }
  scope :is_current, -> { where("end_date >= ?", Date.current) }
  scope :promoted, -> { where(promoted_to_events: true) }

  has_many_attached :images

  validates :images, content_type: ["image/png", "image/jpeg", "image/gif"],
                      size: { less_than: 3.megabytes , message: "is too large" }

  # Exhibition images are attached by hand in Administrate, so unlike events
  # there is no sync to preprocess their derivatives. Without this, the first
  # page view has no derivative to link to and falls back to the Temple T.
  before_save :note_image_attachment_change
  after_commit :preprocess_image_variants, on: [:create, :update]

  def slug_candidates
    [
      :title,
      [:title, :start_date]
    ]
  end

  def label
    title
  end

  def get_date
    return if start_date.blank?

    return start_date.strftime("%^a, %^b %d, %Y").titleize if start_date == end_date

    "#{start_date.strftime("%^a, %^b %d, %Y").titleize} - #{end_date.strftime("%^a, %^b %d, %Y").titleize}"
  end

  def set_start_time
    ""
  end

  def schema_dot_org_type
    "Exhibition"
  end

  def additional_schema_dot_org_attributes
    if self.space.present?
      {
        startDate: start_date,
        endDate: end_date,
        location: {
          "@type" => "Place",
          name: space.label,
          address: {
            "@type" => "PostalAddress",
            streetAddress: space.building.address1,
            addressLocality: space.building.address2
          }
        }
      }
    else
      {
        startDate: start_date,
        endDate: end_date,
        location: {
          "@type" => "Place",
          name: "Online"
        }
      }
    end
  end

  private

    def only_one_highlighted_exhibition
      return unless self.class.where(highlighted: true).where.not(id:).exists?

      errors.add(:base, "Only one exhibition can be highlighted at a time")
    end

    def note_image_attachment_change
      @image_attachment_changed = attachment_changes.key?("image")
      true
    end

    def preprocess_image_variants
      return unless @image_attachment_changed

      @image_attachment_changed = nil
      PreprocessEventImageVariantsJob.perform_later(self) if image.attached?
    end
end
