class CreateSpaceGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :space_groups do |t|
      t.references :space, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
