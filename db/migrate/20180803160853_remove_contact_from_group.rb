class RemoveContactFromGroup < ActiveRecord::Migration[5.2]
  def change
    remove_reference :groups, :chair_dept_head, foreign_key: true
  end
end
