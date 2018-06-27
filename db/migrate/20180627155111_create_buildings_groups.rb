class CreateBuildingsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings_groups do |t|
      t.references :building, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
