# frozen_string_literal: true

class AddFeaturedFieldToFileUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :file_uploads, :featured, :boolean, default: false
  end
end
