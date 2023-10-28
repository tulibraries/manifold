# frozen_string_literal: true

class AddSpaceIdToGroups < ActiveRecord::Migration[7.0]
  def change
    add_reference :groups, :space, null: true, foreign_key: true
  end
end
