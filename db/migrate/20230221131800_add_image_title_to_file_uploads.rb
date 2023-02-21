# frozen_string_literal: true

class AddImageTitleToFileUploads < ActiveRecord::Migration[7.0]
  def change
    add_column :file_uploads, :image_title, :string
  end
end
