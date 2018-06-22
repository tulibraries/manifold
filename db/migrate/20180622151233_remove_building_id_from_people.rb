class RemoveBuildingIdFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_reference :people, :building, foreign_key: true
  end
end
