# frozen_string_literal: true

class MigrateAdminToRole < ActiveRecord::Migration[7.2]
  def up
    execute "UPDATE accounts SET role = 'admin' WHERE admin = TRUE"
    remove_column :accounts, :admin, :boolean
  end

  def down
    add_column :accounts, :admin, :boolean, default: false, null: false
    execute "UPDATE accounts SET admin = TRUE WHERE role = 'admin'"
  end
end
