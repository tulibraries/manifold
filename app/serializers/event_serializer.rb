# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  include ImageSerializable
  include LinkSerializable
  include DescriptionSerializable

  set_type :event

  attributes :title, :start_time, :end_time, :cancelled, :registration_status,
             :registration_link, :content_hash, :alt_text, :ensemble_identifier, :tags, :all_day

  attribute :space do |event|
    if event.space.nil?
      event.external_space
    else
      event.space.name
    end
  end
  attribute :address1 do |event|
    if event.building.nil?
      event.external_address
    else
      event.building.address1
    end
  end

  attribute :address2 do |event|
    if event.building.nil?
      address2 = String.new
      address2 += event.external_city if event.external_city.present?
      address2 += ", " + event.external_state if event.external_state.present?
      address2 += "  " + event.external_zip if event.external_zip.present?
    else
      event.building.address2
    end
  end

  attribute :contact_name do |event|
    if event.person.nil?
      event.external_contact_name
    else
      event.person.first_name + " " + event.person.last_name
    end
  end

  attribute :contact_email do |event|
    if event.person.nil?
      event.external_contact_email
    else
      event.person.email_address
    end
  end

  attribute :contact_phone do |event|
    if event.person.nil?
      event.external_contact_phone
    else
      event.person.phone_number
    end
  end
end
