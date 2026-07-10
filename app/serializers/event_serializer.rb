# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  include ImageSerializable
  include LinkSerializable
  include DescriptionSerializable

  set_type :event

  attributes :title, :start_time, :end_time, :cancelled, :registration_status,
             :registration_link, :alt_text, :ensemble_identifier, :tags, :all_day

  attribute :space do |event|
    event.location_space
  end
  attribute :address1 do |event|
    event.building_address1
  end

  attribute :address2 do |event|
    event.building_address2
  end

  attribute :contact_name do |event|
    event.contact_name
  end

  attribute :contact_email do |event|
    event.contact_email
  end

  attribute :contact_phone do |event|
    event.contact_phone
  end
end
