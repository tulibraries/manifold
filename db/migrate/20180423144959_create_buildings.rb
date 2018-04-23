class CreateBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings do |t|
      t.string :name
      t.text :description
      t.string :address1
      t.string :temple_building_code
      t.string :directions_map
      t.string :hours
      t.string :phone_number
      t.string :image
      t.string :campus
      t.text :accessibility
      t.string :email

      t.timestamps
    end
  end
end
