# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer # ~> NameError: uninitialized constant EventSerializer::FastJsonapi

  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |event| helpers.url_for(event) }

  set_type :event

  attributes :title, :description, :start_time, :end_time, :cancelled, :registration_status
  attributes :registration_link, :content_hash, :alt_text, :ensemble_identifier, :tags, :all_day

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
      address2 += event.external_city unless event.external_city.blank?
      address2 += ", " + event.external_city unless event.external_state.blank?
      address2 += "  " + event.external_zip unless event.external_zip.blank?
    else
      event.building.address2
    end
  end

  attribute :contact_name do |event| # => 
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

  attribute :image, if: Proc.new { |event| event.image.attached? } do |event|
    helpers.rails_blob_url(event.image)
  end

  attribute :thumbnail_image, if: Proc.new { |event| event.image.attached? } do |event|
    helpers.rails_representation_url(event.image.variant(resize: "100x100").processed)
  end
end
