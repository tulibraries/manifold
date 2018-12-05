# frozen_string_literal: true

class RemoveTimeAndDateFieldsFromHighlights < ActiveRecord::Migration[5.2]
  def change
    remove_column :highlights, :date, :date
    remove_column :highlights, :time, :time
    add_column :highlights, :link_label, :string
  end
end
