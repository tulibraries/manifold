# frozen_string_literal: true

class GroupDashboard < BaseDashboard
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
    chair_dept_heads: Field::HasMany,
    member: Field::HasMany,
    persons: Field::HasMany,
    space: Field::BelongsTo.with_options(
      order: "name ASC",
      include_blank: true,
    ),
    external: Field::Boolean,
    group_type: Field::Select.with_options(
      collection: Rails.configuration.group_types
      ),
    parent_group: Field::BelongsTo,
    file_uploads: Field::HasMany,
    webpages: Field::HasMany,
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
    :name,
    :member,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :id,
    :description,
    :group_type,
    :parent_group,
    :chair_dept_heads,
    :persons,
    :space,
    :external,
    :categories,
    :file_uploads
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :slug,
    :description,
    :group_type,
    :parent_group,
    :external,
    :chair_dept_heads,
    :persons,
    :space,
    :categories,
    :webpages,
    :file_uploads
  ].freeze

  # Overwrite this method to customize how groups are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(group)
    "#{group.name}"
  end

  def permitted_attributes
    super + [fileabilities_attributes: [:weight, :id]]
  end
end
