# frozen_string_literal: true

class AddJsonAttributesToAdminGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_groups, :json_attributes, :jsonb

    add_index :admin_groups, :json_attributes, using: :gin
  end
end
