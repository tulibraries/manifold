# frozen_string_literal: true

require "administrate/base_dashboard"

class RedirectDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    legacy_path: Field::String,
    manifold_path: Field::String,
    redirectable: Field::Polymorphic.with_options(
      classes: [
        ::Building.order("name"), ::Category.order("name"), ::Collection.order("name"), ::ExternalLink.order("title"),
        ::Policy.order("name"), ::Service.order("title"), ::Space.order("name"), ::Webpage.order("title")
      ],
      admin_only: true
    ),
    no_message: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :legacy_path
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :legacy_path,
    :manifold_path,
    :redirectable,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :legacy_path,
    :manifold_path,
    :redirectable,
    :no_message,
  ].freeze

  def display_resource(resource)
    "#{resource.legacy_path}"
  end
end
