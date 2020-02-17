# frozen_string_literal: true

class CreateFileUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :file_uploads do |t|
      t.string :name
      t.references :attachable, polymorphic: true

      t.timestamps
    end
  end
end
