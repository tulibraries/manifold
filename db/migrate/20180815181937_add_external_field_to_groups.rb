class AddExternalFieldToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :external, :boolean
  end
end
