# frozen_string_literal: true

class CreateSubjectSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_specialties do |t|
      t.string :name
      t.string :slug
      t.integer :person_id
      t.index :name, unique: true

      t.timestamps
    end
  end
end
