# frozen_string_literal: true

json.extract! library_hour, :id, :location, :date, :hours, :created_at, :updated_at
json.url library_hour_url(library_hour, format: :json)
