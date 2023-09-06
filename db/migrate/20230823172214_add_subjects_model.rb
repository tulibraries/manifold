# frozen_string_literal: true

class AddSubjectsModel < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :slug
      t.index :name, unique: true

      t.timestamps
    end
  end
end
