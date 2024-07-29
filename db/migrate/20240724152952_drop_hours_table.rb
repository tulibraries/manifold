# frozen_string_literal: true

class DropHoursTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :library_hours do |t|
      t.string :location
      t.datetime :date
      t.string :hours
      t.string :location_id
    end
  end
end
