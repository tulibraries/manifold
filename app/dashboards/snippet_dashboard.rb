# frozen_string_literal: true

require "administrate/base_dashboard"

class SnippetDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    description: DescriptionField,
    draft_description: DescriptionField.with_options(admin_only: true),
    id: Field::Number,
    title: Field::String,
    slug: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    updated_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    updated_at
    description
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    slug
    draft_description
    description
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(snippet)
    snippet.title
  end
end
