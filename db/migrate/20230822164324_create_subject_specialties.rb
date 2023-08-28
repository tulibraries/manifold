# frozen_string_literal: true

class CreateSubjectSpecialties < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_specialties do |t|
      t.integer :person_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
