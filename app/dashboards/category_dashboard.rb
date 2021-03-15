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
    slug: Field::String,
    custom_url: Field::String,
    categories: Field::HasMany.with_options(admin_only: true),
    external_link: Field::BelongsTo.with_options(order: "title"),
    description: Field::String,
    long_description: DescriptionField,
    draft_long_description: DescriptionField.with_options(admin_only: true),
    get_help: DescriptionField,
    accounts: Field::HasMany.with_options(admin_only: true),
    covid_alert: DescriptionField.with_options(admin_only: true),
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
    :id,
    :description,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :name,
    :id,
    :image,
    :description,
    :long_description,
    :get_help,
    :custom_url,
    :categories,
    :external_link,
    :accounts,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :slug,
    :image,
    :custom_url,
    :categories,
    :description,
    :long_description,
    :draft_long_description,
    :get_help,
    :external_link,
    :accounts,
    :covid_alert
  ].freeze

  def display_resource(category)
    "#{category.name}"
  end

  def permitted_attributes
    super + [categorizations_attributes: [:weight, :id]] + [:publish, :long_description, :draft_long_description]
  end
end
