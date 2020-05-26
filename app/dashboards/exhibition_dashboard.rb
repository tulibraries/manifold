# frozen_string_literal: true

require "administrate/base_dashboard"

class ExhibitionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    slug: Field::String,
    space: Field::BelongsTo.with_options(required: true),
    collection: Field::BelongsTo,
    image: PhotoField,
    id: Field::Number,
    title: Field::String,
    description: DescriptionField,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    promoted_to_events: Field::Boolean,
    categories: Field::HasMany,
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
    :space,
    :start_date,
    :end_date,
    :promoted_to_events,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :title,
    :id,
    :image,
    :description,
    :start_date,
    :end_date,
    :space,
    :collection,
    :categories
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :slug,
    :image,
    :description,
    :start_date,
    :end_date,
    :promoted_to_events,
    :space,
    :collection,
    :categories
  ].freeze

  # Overwrite this method to customize how exhibitions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(exhibition)
  #   "Exhibition ##{exhibition.id}"
  # end
  def display_resource(exhibition)
    "#{exhibition.title}"
  end

  def tinymce?
    true
  end

  def permitted_attributes
    super + [:draft_title, :draft_description, :publish]
  end
end
