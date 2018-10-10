class AddAddress2FieldToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :address2, :string
  end
end
