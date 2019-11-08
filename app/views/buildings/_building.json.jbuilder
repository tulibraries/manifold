# frozen_string_literal: true

json.extract! building, :id, :name, :description, :address1, :address2, :coordinates, :hours, :phone_number, :email, :google_id, :created_at, :updated_at
json.url building_url(building, format: :json)
