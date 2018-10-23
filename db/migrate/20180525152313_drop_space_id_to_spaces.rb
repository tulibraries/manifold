# frozen_string_literal: true

class DropSpaceIdToSpaces < ActiveRecord::Migration[5.2]
  def change
    remove_column :spaces, :space, :int
  end
end
