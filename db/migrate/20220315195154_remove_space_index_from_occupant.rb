# frozen_string_literal: true

class RemoveSpaceIndexFromOccupant < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      change_table :occupants do |t|
        dir.up   { unless column_exists?(t.space_id) then t.add_references :space_id end }
        dir.down { t.remove :space_id }
      end
    end
  end
end
