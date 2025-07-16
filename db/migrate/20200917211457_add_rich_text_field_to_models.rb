# frozen_string_literal: true

class AddRichTextFieldToModels < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  unless table_exists?(:action_text_rich_texts)
    create_table :action_text_rich_texts do |t|
      t.string     :name, null: false
      t.text       :body
      t.references :record, null: false, polymorphic: true, index: false

      t.timestamps

      t.index [ :record_type, :record_id, :name ], name: "index_action_text_rich_texts_uniqueness", unique: true
    end
  end
end
