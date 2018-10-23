# frozen_string_literal: true

class RemoveAccessibilityFromBuilding < ActiveRecord::Migration[5.2]
  def change
    remove_column :buildings, :accessibility, :text
  end
end
