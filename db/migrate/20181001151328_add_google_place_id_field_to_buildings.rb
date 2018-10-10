class AddGooglePlaceIdFieldToBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :buildings, :google_id, :string
    rename_column :buildings, :directions_map, :coordinates
  end
end
