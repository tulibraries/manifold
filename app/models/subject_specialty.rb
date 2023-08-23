# frozen_string_literal: true

class SubjectSpecialty < ApplicationRecord
  validates :name, presence: true
  belongs_to :person, optional: true
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
end
