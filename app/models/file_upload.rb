# frozen_string_literal: true

class FileUpload < ApplicationRecord
  # has_paper_trail
  include Validators
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_one_attached :file, dependent: :destroy

  validates :name, presence: true
  validates :file, content_type: ["application/pdf"]

  def should_generate_new_friendly_id?
    name_changed? || slug.blank?
  end
end
