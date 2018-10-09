# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email_address
      t.string :chat_handle
      t.string :job_title
      t.string :identifier
      t.references :building, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
