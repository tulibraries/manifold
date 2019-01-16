# frozen_string_literal: true

require "administrate/base_dashboard"

class BlogDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    blog_posts: Field::HasMany,
    id: Field::Number,
    title: Field::String,
    base_url: Field::String,
    feed_path: Field::String,
    last_sync_date: Field::DateTime,
    public_status: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :blog_posts,
    :id,
    :title,
    :base_url,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :base_url,
    :feed_path,
    :last_sync_date,
    :public_status,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :base_url,
    :feed_path,
    :last_sync_date,
    :public_status,
  ].freeze

  def display_resource(blog)
    "##{blog.id} #{blog.title}"
  end

  def tinymce?
    true
  end
end
