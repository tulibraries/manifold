# frozen_string_literal: true

class ChangeLastUpdatedDateToPublicationDateInBlogPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :blog_posts, :last_updated_date, :publication_date
  end
end
