class AddGroupToPerson < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :group, foreign_key: true, optional: true
  end
end
