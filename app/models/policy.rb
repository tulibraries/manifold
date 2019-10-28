# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include InputCleaner
  include Validators
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates_uniqueness_of :slug

  validates :name, :description, :effective_date, presence: true
  serialize :category

  def label
    name
  end
end
