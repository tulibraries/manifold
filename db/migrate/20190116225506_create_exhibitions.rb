# frozen_string_literal: true

class CreateExhibitions < ActiveRecord::Migration[5.2]
  def change
    create_table :exhibitions do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.references :group, foreign_key: true
      t.references :space, foreign_key: true
      t.references :collection, foreign_key: true

      t.timestamps
    end
  end
end
