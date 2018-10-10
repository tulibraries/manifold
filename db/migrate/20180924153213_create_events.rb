# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :building, foreign_key: true
      t.references :space, foreign_key: true
      t.string :external_building
      t.string :external_space
      t.string :external_address
      t.string :external_city
      t.string :external_state
      t.string :external_zip
      t.references :person, foreign_key: true
      t.string :external_contact_name
      t.string :external_contact_email
      t.string :external_contact_phone
      t.boolean :cancelled
      t.boolean :registration_status
      t.string :registration_link
      t.string :content_hash

      t.timestamps
    end
  end
end
