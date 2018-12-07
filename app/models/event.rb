# frozen_string_literal: true

class Event < ApplicationRecord
  include InputCleaner
  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :person, optional: true
  has_one_attached :image, dependent: :destroy

  before_validation :sanitize_description
end
