# frozen_string_literal: true

class RemoveSpaceIdFromPerson < ActiveRecord::Migration[5.2]
  def change
    remove_reference :people, :space, foreign_key: true
  end
end
