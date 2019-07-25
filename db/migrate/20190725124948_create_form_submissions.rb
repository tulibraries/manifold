# frozen_string_literal: true

class CreateFormSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :form_submissions do |t|
      t.text :form_attributes_ciphertext
      t.string :form_type
      t.timestamps
    end
  end
end
