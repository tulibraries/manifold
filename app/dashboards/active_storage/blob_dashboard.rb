require "administrate/base_dashboard"

class ActiveStorage::BlobDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    preview_image_attachment: Field::HasOne,
    preview_image_blob: Field::HasOne,
    attachments: Field::HasMany,
    id: Field::Number,
    key: Field::String,
    filename: Field::String,
    content_type: Field::String,
    metadata: Field::Text,
    byte_size: Field::Number,
    checksum: Field::String,
    created_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  preview_image_attachment
  preview_image_blob
  attachments
  id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  preview_image_attachment
  preview_image_blob
  attachments
  id
  key
  filename
  content_type
  metadata
  byte_size
  checksum
  created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  preview_image_attachment
  preview_image_blob
  attachments
  key
  filename
  content_type
  metadata
  byte_size
  checksum
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how blobs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(blob)
  #   "ActiveStorage::Blob ##{blob.id}"
  # end
end
