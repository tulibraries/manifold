# frozen_string_literal: true

class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :base_url
      t.string :feed_path
      t.datetime :last_sync_date
      t.boolean :public_status, default: false
      t.timestamps
    end
  end
end
