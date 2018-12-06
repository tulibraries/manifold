# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.text :subject
      t.text :contents
      t.references :building, foreign_key: true
      #t.references :policy, foreign_key: true
      #t.references :resource, foreign_key: true

      t.timestamps
    end
  end
end
