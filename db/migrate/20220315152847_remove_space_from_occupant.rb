# frozen_string_literal: true

class RemoveSpaceFromOccupant < ActiveRecord::Migration[6.1]
  def change
    change_table :occupants do |t|
      t.references :building, foreign_key: true
    end
  end
end
