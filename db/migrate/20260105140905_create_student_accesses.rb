# frozen_string_literal: true

class CreateStudentAccesses < ActiveRecord::Migration[7.2]
  def change
    create_table :student_accesses do |t|
      t.references :account, null: false, foreign_key: true
      t.references :student_accessible, null: false, polymorphic: true, index: true

      t.timestamps
    end

    add_index :student_accesses,
              [:account_id, :student_accessible_type, :student_accessible_id],
              unique: true,
              name: "index_student_accesses_unique"
  end
end
