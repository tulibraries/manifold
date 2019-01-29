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
    description: DescriptionField,
    chair_dept_heads: Field::HasMany.with_options(
      class_name: "Person"
    ),
    member: Field::HasMany,
    persons: Field::HasMany,
    space_group: Field::BelongsTo,
    space: SpaceField,
    documents: DocumentField,
    external: Field::Boolean,
    group_type: Field::Select.with_options(
      collection: Rails.configuration.group_types
      ),
    policies: Field::HasMany,
    add_to_footer: Field::Boolean.with_options(admin_only: true),
    parent_group: Field::BelongsTo,
    child_groups: Field::HasMany,
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
    :description,
    :group_type,
    :parent_group,
    :child_groups,
    :chair_dept_heads,
    :persons,
    :space,
    :external,
    :documents,
    :policies,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :group_type,
    :parent_group,
    :external,
    :chair_dept_heads,
    :persons,
    :space,
    :documents,
    :policies,
    :add_to_footer,
  ].freeze

  # Overwrite this method to customize how groups are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(group)
  #   "Group ##{group.id}"
  # end
  def display_resource(group)
    "#{group.name}"
  end

  # permitted for has_many_attached
  def permitted_attributes
    super + [documents: []]
  end

  def tinymce?
    true
  end
end
