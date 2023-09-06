# frozen_string_literal: true

class Subject < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  validates :name, presence: true

  has_many :subject_specialties, dependent: nil
  has_many :people, through: :subject_specialties, source: :person
end
