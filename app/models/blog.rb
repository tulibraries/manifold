# frozen_string_literal: true

class Blog < ApplicationRecord
  include SchemaDotOrgable
  include Validators
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_many :blog_posts, dependent: :destroy

  validates :title, presence: true
  validates :base_url, presence: true, url: true

  attribute :feed_path, :string, default: "/feed"

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  def label
    title
  end
end
