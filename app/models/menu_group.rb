# frozen_string_literal: true

class MenuGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged]

  has_many :categories, dependent: :nullify
end
