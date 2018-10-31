# frozen_string_literal: true

class CreateBlogPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :content
      t.string :path
      t.string :post_guid
      t.datetime :last_updated_date
      t.text :categories
      t.string :external_author_name
      t.references :person, foreign_key: true, index: true
      t.references :blog, foreign_key: true, index: true
      t.timestamps
    end
  end
end
