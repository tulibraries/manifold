# frozen_string_literal: true

class Categorization < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category

  validates :weight, presence: true
end
