# frozen_string_literal: true

class RemoveLocationFromSpace < ActiveRecord::Migration[5.2]
  def change
    remove_column :spaces, :location, :string
  end
end
