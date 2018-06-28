class CreateBuildingGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :building_groups do |t|
      t.references :building, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
