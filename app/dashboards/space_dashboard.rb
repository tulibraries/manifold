# frozen_string_literal: true

class SpaceDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    building: Field::BelongsTo.with_options(required: true),
    slug: Field::String,
    occupant: Field::HasMany,
    persons: Field::HasMany,
    space_group: Field::HasMany,
    groups: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    hours: HoursField.with_options(admin_only: true),
    accessibility: DescriptionField,
    image: PhotoField,
    phone_number: PhoneField,
    email: Field::Email,
    external_link: Field::BelongsTo.with_options(order: "title"),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    ancestry: Field::String,
    categories: Field::HasMany,
    accounts: Field::HasMany.with_options(admin_only: true),
    covid_alert: DescriptionField.with_options(admin_only: true),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :building,
    :phone_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :name,
    :id,
    :image,
    :description,
    :external_link,
    :building,
    :phone_number,
    :email,
    :categories,
    :accounts
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :slug,
    :image,
    :description,
    :draft_description,
    :external_link,
    :accessibility,
    :building,
    :email,
    :hours,
    :phone_number,
    :categories,
    :accounts,
    :covid_alert
  ].freeze

  # Overwrite this method to customize how spaces are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(space)
    "#{space.name}"
  end
end
