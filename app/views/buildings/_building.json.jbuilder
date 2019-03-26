# frozen_string_literal: true

json.extract! building, :id, :name, :description, :address1, :address2, :coordinates, :temple_building_code, :hours, :phone_number, :campus, :email, :google_id, :created_at, :updated_at
json.url building_url(building, format: :json)
