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
    slug: Field::String,
    groups: Field::HasMany,
    occupant: Field::HasMany,
    buildings: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    phone_number: PhoneField,
    email_address: Field::Email,
    chat_handle: Field::String,
    image: PhotoField,
    job_title: Field::String,
    subject_specialties: Field::HasMany,
    springshare_id: SpringshareIdField,
    libguides_account: Field::String,
    research_identifier: Field::String,
    personal_site: Field::String,
    pronouns: Field::String,
    categories: Field::HasMany,
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
    :id,
    :image,
    :phone_number,
    :email_address,
    :chat_handle,
    :job_title,
    :subject_specialties,
    :springshare_id,
    :research_identifier,
    :groups,
    :buildings,
    :personal_site,
    :categories
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :slug,
    :image,
    :pronouns,
    :phone_number,
    :email_address,
    :chat_handle,
    :job_title,
    :subject_specialties,
    :springshare_id,
    :libguides_account,
    :research_identifier,
    :groups,
    :buildings,
    :personal_site,
    :categories
  ].freeze

  # Overwrite this method to customize how people are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(person)
    "#{person.first_name} #{person.last_name}"
  end
end
