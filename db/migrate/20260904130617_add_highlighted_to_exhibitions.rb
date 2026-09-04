# frozen_string_literal: true

class AddHighlightedToExhibitions < ActiveRecord::Migration[8.1]
  def change
    add_column :exhibitions, :highlighted, :boolean, default: false, null: false

    add_index :exhibitions, :highlighted,
              unique: true,
              where: "highlighted",
              name: "index_exhibitions_on_single_highlighted"
  end
end
