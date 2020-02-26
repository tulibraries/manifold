# frozen_string_literal: true

class AddLongDescriptionFieldToCategory < ActiveRecord::Migration[5.2]
  def change
    change_table :categories, bulk: true do |t|
      t.column :long_description, :text
      t.column :description, :string
    end
  end
end
