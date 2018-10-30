# frozen_string_literal: true

class CreateGroupPolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :group_policies do |t|
      t.references :group, foreign_key: true
      t.references :policy, foreign_key: true

      t.timestamps
    end
  end
end
