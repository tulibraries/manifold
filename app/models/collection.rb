# frozen_string_literal: true

class Collection < ApplicationRecord
  include InputCleaner

  validates :name, :description, presence: true

  belongs_to :space
  has_one_attached :photo, dependent: :destroy
  has_many :finding_aids

  serialize :subject

  before_validation :burpArray

  # :subject.reject!{|s| s.empty?}
end
