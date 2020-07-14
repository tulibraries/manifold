# frozen_string_literal: true

class AddLocalTagsToEvents < ActiveRecord::Migration[5.2]
  reversible do |dir|
      change_table :events, bulk: true do |t|
        dir.up do
          t.text :local_tags
        end

        dir.down do
          t.remove :local_tags
        end
      end
    end
end
