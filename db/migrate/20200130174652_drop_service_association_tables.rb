class DropServiceAssociationTables < ActiveRecord::Migration[5.2]
  def change
  	drop_table :service_groups
  	drop_table :service_policies
  	drop_table :service_spaces
  end
end
