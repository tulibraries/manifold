class AddIsAdminFieldToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :is_admin, :string
  end
end
