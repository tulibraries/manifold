# frozen_string_literal: true

class DropServiceAssociationTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :service_groups do |t|
      t.integer "space_id"
      t.integer "group_id"

      t.timestamps
      t.index "index_space_groups_on_group_id", unique: true
      t.index "index_space_groups_on_space_id", unique: true
    end
    drop_table :service_policies do |t|
      t.integer "service_id"
      t.integer "policy_id"

      t.timestamps
      t.index "index_service_policies_on_policy_id", unique: true
      t.index "index_service_policies_on_service_id", unique: true
    end
    drop_table :service_spaces do |t|
      t.integer "service_id"
      t.integer "space_id"

      t.timestamps
      t.index "index_service_spaces_on_service_id", unique: true
      t.index "index_service_spaces_on_space_id", unique: true
    end
  end
end
