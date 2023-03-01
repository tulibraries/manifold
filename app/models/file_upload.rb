# frozen_string_literal: true

class FileUpload < ApplicationRecord
  # has_paper_trail
  include Validators
  extend FriendlyId
  include Imageable
  friendly_id :name, use: [:slugged, :finders]

  has_one_attached :file, dependent: :destroy

  validates :name, presence: true
  validates :file, content_type: ["application/pdf"]
end
