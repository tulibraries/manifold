# frozen_string_literal: true

class Page < ApplicationRecord
  include Accountable
  include Categorizable
  include SetDates
  include Validators
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_uniqueness_of :slug

  has_one_attached :document, dependent: :destroy
  # validates :document, content_type: ["application/pdf"]
  validates :title, :description, presence: true

  belongs_to :group, optional: true

  def label
    title
  end
end
