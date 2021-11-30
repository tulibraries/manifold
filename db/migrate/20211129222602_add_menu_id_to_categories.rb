# frozen_string_literal: true

class AddMenuIdToCategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :categories, :menu_group, foreign_key: true
  end
end
