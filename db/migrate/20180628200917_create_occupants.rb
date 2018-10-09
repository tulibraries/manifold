# frozen_string_literal: true

class CreateOccupants < ActiveRecord::Migration[5.2]
  def change
    create_table :occupants do |t|
      t.references :space, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
