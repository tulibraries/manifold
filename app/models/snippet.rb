# frozen_string_literal: true

class Snippet < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :description
  validates :description, presence: true

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  def label
    title
  end
end
