# frozen_string_literal: true

class Blog < ApplicationRecord
  has_paper_trail
  include Validators
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :blog_posts, dependent: :destroy

  validates :title, presence: true
  validates :base_url, presence: true, url: true


  def feed_path
    attribute(:feed_path) || "/feed"
  end

  def label
    title
  end
end
