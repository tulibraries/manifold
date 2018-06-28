class RemovePersonIdFromGroup < ActiveRecord::Migration[5.2]
  def change
    remove_reference :groups, :person, foreign_key: true
  end
end
