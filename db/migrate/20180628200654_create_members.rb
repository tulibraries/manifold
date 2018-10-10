# frozen_string_literal: true

class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.references :group, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
