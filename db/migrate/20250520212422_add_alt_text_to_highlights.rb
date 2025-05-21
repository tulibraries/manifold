# frozen_string_literal: true

class AddAltTextToHighlights < ActiveRecord::Migration[7.2]
  def up
    add_column :highlights, :image_alt_text, :string
  end
  def down
    remove_column :highlights, :image_alt_text
  end
end
