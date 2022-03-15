# frozen_string_literal: true

class CreateMenuGroupCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_group_categories do |t|
      t.integer :menu_group_id
      t.integer :category_id

      t.timestamps
    end
  end
end
