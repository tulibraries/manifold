# frozen_string_literal: true

class PersonDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    member: Field::HasMany,
    groups: Field::HasMany,
    occupant: Field::HasMany,
    spaces: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    phone_number: PhoneField,
    email_address: Field::Email,
    chat_handle: Field::String,
    photo: PhotoField.with_options(admin_only: true),
    job_title: Field::String,
    springshare_id: SpringshareIdField,
    research_identifier: Field::String,
    personal_site: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :first_name,
    :last_name,
    :job_title,
    :phone_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :photo,
    :phone_number,
    :email_address,
    :chat_handle,
    :job_title,
    :springshare_id,
    :research_identifier,
    :groups,
    :spaces,
    :personal_site,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :photo,
    :first_name,
    :last_name,
    :phone_number,
    :email_address,
    :chat_handle,
    :job_title,
    :springshare_id,
    :research_identifier,
    :groups,
    :spaces,
    :personal_site,
  ].freeze

  # Overwrite this method to customize how people are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(person)
    "#{person.first_name} #{person.last_name}"
  end
end
