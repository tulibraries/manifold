# frozen_string_literal: true

class Collection < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :space
  has_one_attached :photo, dependent: :destroy
  has_many :finding_aids
end
