# frozen_string_literal: true

class AddFieldsToCategories < ActiveRecord::Migration[5.2]
  def change
    change_column :categories, :description, :text
    add_column :categories, :get_help, :text
  end
end
