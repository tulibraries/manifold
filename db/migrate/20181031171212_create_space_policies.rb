# frozen_string_literal: true

class CreateSpacePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :space_policies do |t|
      t.references :space, foreign_key: true
      t.references :policy, foreign_key: true

      t.timestamps
    end
  end
end
