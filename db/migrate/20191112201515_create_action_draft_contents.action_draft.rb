# frozen_string_literal: true
# This migration comes from action_draft (originally 20190724102032)

class CreateActionDraftContents < ActiveRecord::Migration[5.2]
  def change
    create_table :action_draft_contents do |t|
      t.references :record, null: false, polymorphic: true, index: false
      t.string :name
      t.text :content, limit: 16777215

      t.timestamps

      t.index [ :record_type, :record_id, :name ], name: "index_action_drafts_uniqueness", unique: true
    end
  end
end
