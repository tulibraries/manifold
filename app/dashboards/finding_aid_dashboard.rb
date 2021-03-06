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
    slug: Field::String,
    subject: MultiSelectField.with_options(
      collection: Rails.configuration.finding_aid_subjects
    ),
    content_link: Field::String,
    identifier: Field::String,
    path: Field::String.with_options(admin_only: true),
    collections: Field::HasMany.with_options(
      class_name: "Collection"
    ),
    person: Field::HasMany.with_options(
      class_name: "Person"
    ),
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
    :collections,
    :person,
    :categories,
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
  def display_resource(finding_aid)
    "#{finding_aid.name}"
  end

  def tinymce?
    true
  end

  def permitted_attributes
    super + [:draft_description, :publish]
  end
end
