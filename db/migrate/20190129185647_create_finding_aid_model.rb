# frozen_string_literal: true

class CreateFindingAidModel < ActiveRecord::Migration[5.2]
  def change
    create_table :finding_aids do |t|
      t.string :name
      t.text :description
      t.string :subject
      t.string :content_link
      t.string :identifier
      t.references :collection, foreign_key: true

      t.timestamps
    end
    create_table :finding_aid_responsibilities do |t|
      t.belongs_to :finding_aid, index: true
      t.belongs_to :person, index: true

      t.timestamps
    end
  end
end
