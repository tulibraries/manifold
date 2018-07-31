class AddContactToGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :chair_dept_head, foreign_key: true
  end
end
