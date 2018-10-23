# frozen_string_literal: true

class AddSpaceIdToSpaces < ActiveRecord::Migration[5.2]
  def change
    add_column :spaces, :space, :int
  end
end
