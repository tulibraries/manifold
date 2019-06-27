# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include Categorizable
  validates :name, :description, :effective_date, presence: true
  serialize :category

  def label
    name
  end
end
