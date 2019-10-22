# frozen_string_literal: true

class Policy < ApplicationRecord
  has_paper_trail

  include Accountable
  include Categorizable
  include InputCleaner
  include Validators

  validates :name, :description, :effective_date, presence: true
  serialize :category

  def label
    name
  end
end
