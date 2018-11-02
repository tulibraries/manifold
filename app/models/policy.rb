# frozen_string_literal: true

class Policy < ApplicationRecord
  include Validators
  include InputCleaner
  validates :name, :description, :effective_date, presence: true

  belongs_to :policy_makeable, polymorphic: true
end
