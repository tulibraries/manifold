# frozen_string_literal: true

require "administrate/base_dashboard"

class BlogPostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    blog: Field::BelongsTo,
    person: Field::BelongsTo,
    id: Field::Number,
    title: Field::String,
    content: Field::Text,
    path: Field::String,
    post_guid: Field::String,
    publication_date: Field::DateTime,
    categories: Field::Text,
    external_author_name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    content_hash: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :blog,
    :person,
    :id,
    :title,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :blog,
    :person,
    :id,
    :title,
    :content,
    :path,
    :post_guid,
    :publication_date,
    :categories,
    :external_author_name,
    :created_at,
    :updated_at,
    :content_hash,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :blog,
    :person,
    :title,
    :content,
    :path,
    :post_guid,
    :publication_date,
    :categories,
    :external_author_name,
    :content_hash,
  ].freeze

  # Overwrite this method to customize how blog posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(blog_post)
  #   "BlogPost ##{blog_post.id}"
  # end

  def tinymce?
    true
  end
end
