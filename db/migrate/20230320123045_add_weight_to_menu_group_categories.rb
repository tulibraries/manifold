# frozen_string_literal: true

class AddWeightToMenuGroupCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :menu_group_categories, :weight, :integer, default: 10
  end
end
