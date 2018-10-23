# frozen_string_literal: true

class AddAncestryToSpace < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :ancestry, :string
    add_index :spaces, :ancestry
  end
end
