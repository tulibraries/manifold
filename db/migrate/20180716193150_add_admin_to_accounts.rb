class AddAdminToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :admin, :boolean, default: false
  end
end
