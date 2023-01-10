# frozen_string_literal: true

class CreateSnippets < ActiveRecord::Migration[7.0]
  def change
    create_table :snippets do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
