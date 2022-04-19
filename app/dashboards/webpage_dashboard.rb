# frozen_string_literal: true

require "administrate/base_dashboard"

class WebpageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    slug: Field::String,
    group: Field::BelongsTo,
    id: Field::Number,
    title: Field::String,
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    layout: Field::Select.with_options(
      collection: Rails.configuration.page_layouts,
      multiple: false,
      ),
    virtual_tour: Field::String,
    categories: Field::HasMany,
    accounts: Field::HasMany.with_options(admin_only: true),
    external_link: Field::BelongsTo.with_options(order: "title"),
    file_uploads: Field::HasMany,
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
    :title,
    :slug
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :covid_alert,
    :title,
    :id,
    :description,
    :categories,
    :accounts,
    :covid_alert,
    :file_uploads
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :slug,
    :description,
    :draft_description,
    :group,
    :categories,
    :virtual_tour,
    :accounts,
    :layout,
    :external_link,
    :file_uploads,
    :covid_alert
  ].freeze

  # Overwrite this method to customize how pages are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(page)
  #   "Page ##{page.id}"
  # end

  # permitted for has_many_attached
  # def permitted_attributes
  #   super + [documents: []]
  # end

  def display_resource(webpage)
    webpage.title
  end


  def permitted_attributes
    super + [:draft_description, :publish]
  end
end
