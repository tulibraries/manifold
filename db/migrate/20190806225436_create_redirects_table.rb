# frozen_string_literal: true

class CreateRedirectsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :redirects do |t|
      t.string :legacy_path
      t.string :manifold_path
      t.references :redirectable, polymorphic: true, index: true
      t.timestamps
    end
    add_index :redirects, :legacy_path
  end
end
