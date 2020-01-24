# frozen_string_literal: true

class AddFileUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :file_uploads do |t|
      t.string :name
      t.timestamps
    end
    add_reference :services, :file_upload, foreign_key: true
    add_reference :spaces, :file_upload, foreign_key: true
    add_reference :webpages, :file_upload, foreign_key: true
    add_reference :policies, :file_upload, foreign_key: true
    add_reference :groups, :file_upload, foreign_key: true
  end
end
