# frozen_string_literal: true

class RemoveParentSpaceIdFromSpace < ActiveRecord::Migration[5.2]
  def change
    remove_reference :spaces, :parent_space, foreign_key: true
  end
end
