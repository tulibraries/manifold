# frozen_string_literal: true

class AddTagsFieldToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :tags, :text
  end
end
