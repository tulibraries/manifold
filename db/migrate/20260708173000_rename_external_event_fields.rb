# frozen_string_literal: true

class RenameExternalEventFields < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :external_contact_name, :contact_name
    rename_column :events, :external_contact_email, :contact_email
    rename_column :events, :external_contact_phone, :contact_phone
    rename_column :events, :external_building, :location_name
    rename_column :events, :external_space, :location_space
    rename_column :events, :external_address, :address
    rename_column :events, :external_city, :city
    rename_column :events, :external_state, :state
    rename_column :events, :external_zip, :zip
  end
end
