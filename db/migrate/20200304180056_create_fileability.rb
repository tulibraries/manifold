# frozen_string_literal: true

class CreateFileability < ActiveRecord::Migration[5.2]
  def change
    create_table :fileabilities do |t|
      t.references :attachable, polymorphic: true, index: false
      t.references :file_upload
      t.timestamps
    end

    add_index :fileabilities,
     [:file_upload_id, :attachable_id, :attachable_type],
     name: "polymorphic_fileability",
     unique: true
  end
end
