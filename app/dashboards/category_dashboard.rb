# frozen_string_literal: true

require "administrate/base_dashboard"

class CategoryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    image: PhotoField.with_options(admin_only: true),
    id: Field::Number,
    name: Field::String,
    slug: Field::String.with_options(admin_only: true),
    custom_url: Field::String,
    categories: Field::HasMany.with_options(admin_only: true),
    description: DescriptionField,
    get_help: DescriptionField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    #:categorizations,
    :name,
    :id,
    :description,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :image,
    :id,
    :name,
    :description,
    :get_help,
    :custom_url,
    :description,
    :categories,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :image,
    :name,
    :slug,
    :custom_url,
    :categories,
    :description,
    :get_help
  ].freeze

  def display_resource(category)
    "#{category.name}"
  end

  def tinymce?
    true
  end
end
