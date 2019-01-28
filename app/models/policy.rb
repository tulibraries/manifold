# frozen_string_literal: true

class Policy < ApplicationRecord
  include Validators
  include InputCleaner
  validates :name, :description, :effective_date, presence: true
  serialize :category
end
