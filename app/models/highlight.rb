# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  has_paper_trail
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_uniqueness_of :slug

  serialize :tags

  def label
    title
  end
end
