# frozen_string_literal: true

class Blog < ApplicationRecord
  include Validators

  validates :title, presence: true
  validates :base_url, presence: true, url: true


  def feed_path
    attribute(:feed_path) || "/feed"
  end
end
