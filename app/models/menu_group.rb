# frozen_string_literal: true

class MenuGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged]

  has_many :menu_group_categories, dependent: :destroy
  has_many :categories, through: :menu_group_categories
end
