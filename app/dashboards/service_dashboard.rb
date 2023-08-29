# frozen_string_literal: true

require "administrate/base_dashboard"

class ServiceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    slug: Field::String,
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    access_description: DescriptionField,
    draft_access_description: DescriptionField.with_options(admin_only: true),
    external_link: Field::BelongsTo.with_options(order: "title"),
    intended_audience: MultiSelectField.with_options(
      collection: Rails.configuration.audience_types
    ),
    hours: HoursField.with_options(admin_only: true),
    categories: Field::HasMany,
    accounts: Field::HasMany.with_options(admin_only: true),
    covid_alert: DescriptionField.with_options(admin_only: true),
    file_uploads: Field::HasMany.with_options(
      order: "name",
      class_name: "FileUpload"
    ),
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
    :categories,
    :accounts,
    :updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :title,
    :id,
    :description,
    :access_description,
    :intended_audience,
    :external_link,
    :categories,
    :accounts,
    :covid_alert,
    :file_uploads,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :slug,
    :description,
    :draft_description,
    :access_description,
    :draft_access_description,
    :external_link,
    :intended_audience,
    :hours,
    :categories,
    :accounts,
    :file_uploads,
    :covid_alert
  ].freeze

  def display_resource(service)
    "#{service.title}"
  end


  # def permitted_attributes
  #   super + [:draft_description, :draft_access_description, :publish]
  # end
end
