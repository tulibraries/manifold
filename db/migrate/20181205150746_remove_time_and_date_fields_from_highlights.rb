# frozen_string_literal: true

class RemoveTimeAndDateFieldsFromHighlights < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :highlights, bulk: true do |t|
        dir.up do
          t.remove :date
          t.remove :time
          t.string :link_label
        end

        dir.down do
          t.date :date
          t.time :time
          t.remove :link_label
        end
      end
    end
  end
end
