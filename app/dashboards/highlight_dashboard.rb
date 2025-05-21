# frozen_string_literal: true

require "administrate/base_dashboard"

class HighlightDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    image: PhotoField,
    image_alt_text: Field::String,
    slug: Field::String,
    title: Field::String,
    blurb: Field::Text,
    link_label: Field::String,
    link: Field::String,
    type_of_highlight: Field::Select.with_options(
      collection: Rails.configuration.highlight_types,
      multiple: true,
      ),
    tags: Field::String,
    promoted: Field::Boolean,
    promote_to_dig_col: Field::Boolean,
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
    :promoted,
    :promote_to_dig_col,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :title,
    :id,
    :image,
    :blurb,
    :link_label,
    :link,
    :type_of_highlight,
    :tags,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :image,
    :image_alt_text,
    :title,
    :slug,
    :blurb,
    :link_label,
    :link,
    :type_of_highlight,
    :tags,
    :promoted,
    :promote_to_dig_col,
  ].freeze

  # Overwrite this method to customize how highlights are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(highlight)
  #   "Highlight ##{highlight.id}"
  # end
end
