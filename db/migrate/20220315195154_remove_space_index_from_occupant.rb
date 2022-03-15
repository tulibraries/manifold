class RemoveSpaceIndexFromOccupant < ActiveRecord::Migration[6.1]
  def change
    change_table :occupants do |t|
      t.remove :space_id
    end
  end
end
