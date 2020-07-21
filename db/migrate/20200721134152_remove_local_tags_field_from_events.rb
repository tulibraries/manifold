# frozen_string_literal: true

class RemoveLocalTagsFieldFromEvents < ActiveRecord::Migration[5.2]
  reversible do |dir|
      change_table :events do |t|
        dir.up do
          t.remove :local_tags
        end

        dir.down do
          t.text :local_tags
        end
      end
    end
end
