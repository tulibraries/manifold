# frozen_string_literal: true

class AddFieldsToBuildings < ActiveRecord::Migration[5.2]
  reversible do |dir|
      change_table :buildings, bulk: true do |t|
        dir.up do
          t.string :city
          t.string :state
          t.string :zipcode
        end

        dir.down do
          t.remove :city
          t.remove :state
          t.remove :zipcode
        end
      end
    end
end
