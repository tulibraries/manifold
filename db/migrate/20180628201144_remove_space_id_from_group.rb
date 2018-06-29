class RemoveSpaceIdFromGroup < ActiveRecord::Migration[5.2]
  def change
    remove_reference :groups, :space, foreign_key: true
  end
end
