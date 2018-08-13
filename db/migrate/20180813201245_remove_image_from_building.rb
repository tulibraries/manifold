class RemoveImageFromBuilding < ActiveRecord::Migration[5.2]
  def change
    remove_column :buildings, :image, :string
  end
end
