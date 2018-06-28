class CreateBuildingPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :building_people do |t|
      t.references :building, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
