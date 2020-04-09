# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  has_paper_trail
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  serialize :tags

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
