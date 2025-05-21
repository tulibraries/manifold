# frozen_string_literal: true

class AddAltTextToFileUploads < ActiveRecord::Migration[7.2]
  def up
    add_column :file_uploads, :image_alt_text, :string
  end
  def down
    remove_column :file_uploads, :image_alt_text
  end
end
