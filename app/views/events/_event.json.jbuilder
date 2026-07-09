# frozen_string_literal: true

json.extract! event, :id, :title, :description, :start_time, :end_time, :building_id, :space_id, :location_name, :location_space, :address, :city, :state, :zip, :person_id, :contact_name, :contact_email, :contact_phone, :cancelled, :registration_status, :registration_link, :created_at, :updated_at
json.url event_url(event, format: :json)
