# frozen_string_literal: true

class AddRoleToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :role, :string, null: false, default: "regular"
  end
end
