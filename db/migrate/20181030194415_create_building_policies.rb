# frozen_string_literal: true

class CreateBuildingPolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :building_policies do |t|
      t.references :building, foreign_key: true
      t.references :policy, foreign_key: true

      t.timestamps
    end
  end
end
