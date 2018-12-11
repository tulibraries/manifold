# frozen_string_literal: true

class AddContentHashToBlogPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :blog_posts, :content_hash, :string
  end
end
