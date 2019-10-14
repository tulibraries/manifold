# frozen_string_literal: true

class Collection < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable

  validates :name, :description, presence: true

  belongs_to :space
  belongs_to :external_link, optional: true

  has_many :collection_aids
  has_many :finding_aids, through: :collection_aids

  serialize :subject

  before_validation :burpArray
end
