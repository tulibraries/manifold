# frozen_string_literal: true

class RemoveFeaturedFromFileUploads < ActiveRecord::Migration[7.0]
  def change
    remove_column :file_uploads, :featured, :boolean
  end
end
