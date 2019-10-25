# frozen_string_literal: true

class AddLongDescriptionFieldToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :long_description, :text
    change_column :categories, :description, :string
  end
end
