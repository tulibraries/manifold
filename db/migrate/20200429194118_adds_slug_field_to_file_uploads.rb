# frozen_string_literal: true

class AddsSlugFieldToFileUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :file_uploads, :slug, :string, unique: true
  end
end
