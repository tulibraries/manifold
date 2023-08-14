# frozen_string_literal: true

class FormInfo < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  friendly_id :slug_candidates, use: :slugged
  has_rich_text :intro
end
