class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :phone_number
      t.string :email_address
      t.references :person, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
