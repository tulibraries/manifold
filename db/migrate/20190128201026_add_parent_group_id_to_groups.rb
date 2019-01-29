class AddParentGroupIdToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :parent_group
  end
end
