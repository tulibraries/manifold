# frozen_string_literal: true

class AddSlugToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :slug, :string
  end
end
