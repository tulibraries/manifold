# frozen_string_literal: true

class DropActionDraftContentsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :action_draft_contents do |t|
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.string "name"
      t.text "content"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["record_type", "record_id", "name"], name: "index_action_drafts_uniqueness", unique: true
    end
  end
end
