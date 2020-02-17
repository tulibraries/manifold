# frozen_string_literal: true

class FileUpload < ApplicationRecord
  # has_paper_trail
  include Validators
  has_one_attached :file, dependent: :destroy
  validates :name, presence: true
  validates :file, content_type: ["application/pdf"]
end
