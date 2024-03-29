# frozen_string_literal: true

require "administrate/base_dashboard"

class PolicyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    slug: Field::String,
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    effective_date: Field::DateTime,
    expiration_date: Field::DateTime,
    categories: Field::HasMany,
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
    :id,
    :name,
    :categories,
    :effective_date,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :name,
    :id,
    :description,
    :effective_date,
    :expiration_date,
    :categories,
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
    :description,
    :draft_description,
    :effective_date,
    :expiration_date,
    :categories,
    :accounts,
    :covid_alert
  ].freeze

  def display_resource(policy)
    "#{policy.name}"
  end
end
