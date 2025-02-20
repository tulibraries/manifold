# frozen_string_literal: true

class CreateExternalLinkWebpages < ActiveRecord::Migration[7.2]
  def change
    create_table :external_link_webpages do |t|
      t.references :webpage, null: false, foreign_key: true
      t.references :external_link, null: false, foreign_key: true
      t.integer :weight, default: 10

      t.timestamps
    end
  end
end
