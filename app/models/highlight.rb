# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  has_paper_trail
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  validates :title, presence: true

  serialize :tags

  scope :with_image, -> { joins(:image_attachment) }
  scope :with_image_and_alt_text, -> { with_image.where.not(image_alt_text: nil) }
  scope :for_digital_collections, -> { where(promote_to_dig_col: true) }

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def label
    title
  end
end
