# frozen_string_literal: true

class Page < ApplicationRecord
  include Validators
  include Categorizable
  include SetDates

  has_one_attached :document, dependent: :destroy
  # validates :document, content_type: ["application/pdf"]
  validates :title, :description, presence: true

  belongs_to :group, optional: true
end
