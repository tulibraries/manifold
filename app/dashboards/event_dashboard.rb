# frozen_string_literal: true

require "administrate/base_dashboard"

class EventDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    building: Field::BelongsTo,
    space: Field::BelongsTo,
    person: Field::BelongsTo,
    slug: Field::String,
    id: Field::Number,
    title: Field::String,
    description: DescriptionField,
    tags: Field::String,
    event_type: Field::String,
    start_time: Field::DateTime.with_options(format: "%D - %I:%M %p"),
    end_time: Field::DateTime.with_options(format: "%D - %I:%M %p"),
    all_day: Field::Boolean,
    external_building: Field::String,
    external_space: Field::String,
    external_address: Field::String,
    external_city: Field::String,
    external_state: Field::String,
    external_zip: Field::String,
    external_contact_name: Field::String,
    external_contact_email: Field::String,
    external_contact_phone: Field::String,
    cancelled: Field::Boolean,
    registration_status: Field::Boolean,
    registration_link: Field::String,
    event_url: Field::String,
    content_hash: Field::String,
    image: PhotoField,
    alt_text: Field::String,
    ensemble_identifier: Field::String,
    categories: Field::HasMany,
    guid: Field::String,
    featured: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :featured,
    :event_type,
    :start_time,
    :end_time,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :title,
    :id,
    :description,
    :event_type,
    :tags,
    :start_time,
    :end_time,
    :all_day,
    :image,
    :alt_text,
    :building,
    :space,
    :external_building,
    :external_space,
    :external_address,
    :external_city,
    :external_state,
    :external_zip,
    :person,
    :external_contact_name,
    :external_contact_email,
    :external_contact_phone,
    :cancelled,
    :registration_status,
    :registration_link,
    :content_hash,
    :ensemble_identifier,
    :guid,
    :categories,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :image,
    :alt_text,
    :slug,
    :description,
    :event_type,
    :featured,
    :tags,
    :start_time,
    :end_time,
    :all_day,
    :building,
    :space,
    :external_building,
    :external_space,
    :external_address,
    :external_city,
    :external_state,
    :external_zip,
    :person,
    :external_contact_name,
    :external_contact_email,
    :external_contact_phone,
    :cancelled,
    :registration_status,
    :registration_link,
    :event_url,
    :content_hash,
    :ensemble_identifier,
    :guid,
    # :categories # TODO: make work with url_for in category pages and main menu category.items
  ].freeze

  # Overwrite this method to customize how events are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(event)
    "#{event.title}"
  end
end
