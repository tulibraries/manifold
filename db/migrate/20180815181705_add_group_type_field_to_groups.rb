# frozen_string_literal: true

class AddGroupTypeFieldToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :group_type, :string
  end
end
