require "administrate/base_dashboard"

class BuildingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    address1: Field::String,
    temple_building_code: Field::String,
    directions_map: Field::String,
    hours: Field::String,
    phone_number: Field::String,
    image: Field::String,
    campus: Field::String,
    accessibility: Field::Text,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :address1,
    :campus,
    :phone_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    # :id,
    :name,
    :description,
    :address1,
    :temple_building_code,
    :directions_map,
    :hours,
    :phone_number,
    :image,
    :campus,
    :accessibility,
    :email,
    # :created_at,
    # :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :address1,
    :temple_building_code,
    :directions_map,
    :hours,
    :phone_number,
    :image,
    :campus,
    :accessibility,
    :email,
  ].freeze

  # Overwrite this method to customize how buildings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(building)
  #   "Building ##{building.id}"
  # end
end
