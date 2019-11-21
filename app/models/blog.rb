# frozen_string_literal: true

class Blog < ApplicationRecord
  has_paper_trail
  include Validators
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged
  validates_presence_of :slug

  has_many :blog_posts, dependent: :destroy

  validates :title, presence: true
  validates :base_url, presence: true, url: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def feed_path
    attribute(:feed_path) || "/feed"
  end

  def label
    title
  end
end
