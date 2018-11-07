# frozen_string_literal: true

class Collection < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :building
end
