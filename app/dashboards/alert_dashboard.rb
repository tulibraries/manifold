# frozen_string_literal: true

require "administrate/base_dashboard"

class AlertDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    scroll_text: Field::String,
    link: Field::String,
    description:  DescriptionField,
    published: Field::Boolean,
    for_header: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :published,
    :for_header,
    :scroll_text,
    :link,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :scroll_text,
    :link,
    :description,
    :published,
    :for_header,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :scroll_text,
    :link,
    :description,
    :published,
    :for_header,
  ].freeze

  # Overwrite this method to customize how alerts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(alert)
  #   "Alert ##{alert.id}"
  # end
end
