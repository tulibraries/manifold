# frozen_string_literal: true

class AddFieldsToPerson < ActiveRecord::Migration[6.1]
  def change
    change_table :people do |t|
      t.string :pronouns
      t.references :building, foreign_key: true
    end

    reversible do |dir|
      change_table :occupants do |t|
        t.references :building, foreign_key: true
        t.remove :space_id
      end
    end
  end
end
