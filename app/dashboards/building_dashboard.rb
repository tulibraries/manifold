class BuildingDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String.with_options(required: true),
    description: DescriptionField.with_options(required: true),
    address1: Field::String.with_options(required: true),
    temple_building_code: Field::String.with_options(required: true),
    coordinates: Field::String.with_options(required: true),
    google_id: Field::String.with_options(required: true),
    hours: HoursField,
    phone_number: PhoneField.with_options(required: true),
    campus: Field::String.with_options(required: true),
    email: Field::Email,
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
    :address1,
    :campus,
    :phone_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
    :address1,
    :temple_building_code,
    :hours,
    :phone_number,
    :campus,
    :email,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :campus,
    :address1,
    :phone_number,
    :temple_building_code,
    :coordinates,
    :google_id,
    :hours,
    :email,
  ].freeze

  # Overwrite this method to customize how buildings are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(building)
    "#{building.name}"
  end

  def tinymce?
    true
  end
end
