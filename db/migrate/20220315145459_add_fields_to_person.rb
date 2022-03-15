# frozen_string_literal: true

class AddFieldsToPerson < ActiveRecord::Migration[6.1]
  def change
    change_table :people do |t|
      t.string :pronouns
      t.references :building, foreign_key: true
    end
  end
end
