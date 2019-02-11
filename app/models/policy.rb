# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  validates :name, :description, :effective_date, presence: true
  serialize :category
end
