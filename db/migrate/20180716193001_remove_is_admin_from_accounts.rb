class RemoveIsAdminFromAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :accounts, :is_admin, :string
  end
end
