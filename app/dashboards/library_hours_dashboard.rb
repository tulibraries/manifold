require "administrate/base_dashboard"

class LibraryHoursDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # versions: Field::HasMany.with_options(class_name: "PaperTrail::Version"),
    building: Field::BelongsTo,
    space: Field::BelongsTo,
    service: Field::BelongsTo,
    id: Field::Number,
    location: Field::String,
    date: Field::DateTime,
    hours: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    location_id: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    # :versions,
    :building,
    :space,
    :service,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    # :versions,
    :building,
    :space,
    :service,
    :id,
    :location,
    :date,
    :hours,
    :created_at,
    :updated_at,
    :location_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :versions,
    :building,
    :space,
    :service,
    :location,
    :date,
    :hours,
    :location_id,
  ].freeze

  # Overwrite this method to customize how library hours are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(library_hours)
  #   "LibraryHours ##{library_hours.id}"
  # end
end
