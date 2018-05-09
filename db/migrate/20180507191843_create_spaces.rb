class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.string :name
      t.text :description
      t.string :hours
      t.text :accessibility
      t.string :location
      t.string :phone_number
      t.string :image
      t.string :email
      t.references :building, foreign_key: true, required: true
      t.references :space, foreign_key: true, requred: false

      t.timestamps
    end
  end
end
