require "administrate/base_dashboard"

class EventDashboard < Administrate::BaseDashboard
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
    id: Field::Number,
    title: Field::String,
    description: DescriptionField.with_options(required: true),
    start_time: Field::DateTime,
    end_time: Field::DateTime,
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
    content_hash: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :start_time,
    :end_time,
    :person,
    :building,
    :space,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :description,
    :start_time,
    :end_time,
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
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :description,
    :start_time,
    :end_time,
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
  ].freeze

  # Overwrite this method to customize how events are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(event)
    "Event ##{event.id}"
  end
  
  def tinymce?
    true
  end
end
