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
    subject: MultiSelectField.with_options(
      collection: Rails.configuration.finding_aid_subjects,
      multiple: true,
      include_blank: false,
    ),
    content_link: Field::String,
    identifier: Field::String,
    collection: Field::BelongsTo,
    person: Field::HasMany,
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
    :collection,
    :person,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
    :subject,
    :content_link,
    :identifier,
    :collection,
    :person,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :identifier,
    :description,
    :subject,
    :content_link,
    :collection,
    :person,
  ].freeze

  # Overwrite this method to customize how finding aids are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(finding_aid)
  #   "FindingAid ##{finding_aid.id}"
  # end

  def tinymce?
    true
  end
end
