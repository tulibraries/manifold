# frozen_string_literal: true

class Blog < ApplicationRecord
  has_paper_trail
  include Validators

  has_many :blog_posts

  validates :title, presence: true
  validates :base_url, presence: true, url: true


  def feed_path
    attribute(:feed_path) || "/feed"
  end
end
