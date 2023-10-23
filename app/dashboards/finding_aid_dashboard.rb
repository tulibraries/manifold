# frozen_string_literal: true

require "administrate/base_dashboard"

class FindingAidDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    slug: Field::String,
    subject: MultiSelectField.with_options(
      collection: Rails.configuration.finding_aid_subjects
    ),
    content_link: Field::String,
    identifier: Field::String,
    path: Field::String.with_options(admin_only: true),
    collections: Field::HasMany,
    person: Field::HasMany,
    categories: Field::HasMany,
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
    # :collections,
    # :person,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :name,
    :id,
    :subject,
    :content_link,
    :identifier,
    :path,
    :description,
    :collections,
    :person,
    :categories,
    :covid_alert,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :slug,
    :identifier,
    :path,
    :draft_description,
    :description,
    :collections,
    :subject,
    :content_link,
    :person,
    :categories,
    :covid_alert
  ].freeze

  # Overwrite this method to customize how finding aids are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(findingaid)
    "#{findingaid.name}"
  end
end
