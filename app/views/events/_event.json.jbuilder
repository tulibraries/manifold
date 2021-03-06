# frozen_string_literal: true

json.extract! event, :id, :title, :description, :start_time, :end_time, :building_id, :space_id, :external_building, :external_space, :external_address, :external_city, :external_state, :external_zip, :person_id, :external_contact_name, :external_contact_email, :external_contact_phone, :cancelled, :registration_status, :registration_link, :content_hash, :created_at, :updated_at
json.url event_url(event, format: :json)
