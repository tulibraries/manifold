class RemoveBuildingIdFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_reference :groups, :building, foreign_key: true
  end
end
