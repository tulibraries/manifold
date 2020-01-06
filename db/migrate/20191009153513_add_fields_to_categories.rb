# frozen_string_literal: true

class AddFieldsToCategories < ActiveRecord::Migration[5.2]
  def change
    change_table :categories, bulk: true do |t|
      t.column :description, :text
      t.column :get_help, :text
    end
  end
end
