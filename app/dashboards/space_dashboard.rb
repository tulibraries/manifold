require "administrate/base_dashboard"

class SpaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    building: Field::BelongsTo,
    occupant: Field::HasMany,
    persons: Field::HasMany,
    space_group: Field::HasMany,
    groups: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    hours: Field::String,
    accessibility: Field::Text,
    location: Field::String,
    phone_number: Field::String,
    image: Field::String,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    ancestry: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :building,
    :location,
    :phone_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    # :id,
    :name,
    :image,
    :description,
    :building,
    :occupant,
    :persons,
    # :space_group,
    :groups,
    :hours,
    :accessibility,
    :location,
    :phone_number,
    :email,
    # :created_at,
    # :updated_at,
    # :ancestry,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :image,
    :description,
    :building,
    :occupant,
    :persons,
    # :space_group,
    :groups,
    :hours,
    :accessibility,
    :location,
    :phone_number,
    :email,
    # :ancestry,
  ].freeze

  # Overwrite this method to customize how spaces are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(space)
  #   "Space ##{space.id}"
  # end
end
