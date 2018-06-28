class RemoveGroupIdFromPerson < ActiveRecord::Migration[5.2]
  def change
    remove_reference :people, :group, foreign_key: true
  end
end
