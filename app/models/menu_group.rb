# frozen_string_literal: true

class MenuGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged]

  has_many :menu_group_categories, dependent: :destroy
  has_many :categories, through: :menu_group_categories

  accepts_nested_attributes_for :menu_group_categories

  def items
    self.categories.sort_by { |menu_group| menu_group&.weight }
  end
end
