class CreateMenuGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_groups do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
