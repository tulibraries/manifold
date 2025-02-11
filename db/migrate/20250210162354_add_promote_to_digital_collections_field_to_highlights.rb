# frozen_string_literal: true

class AddPromoteToDigitalCollectionsFieldToHighlights < ActiveRecord::Migration[7.2]
  def up
    add_column :highlights, :promote_to_dig_col, :boolean, default: false
  end
  def down
    remove_column :highlights, :promote_to_dig_col, :boolean
  end
end
