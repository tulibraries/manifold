# frozen_string_literal: true

class Highlight < ApplicationRecord
  has_one_attached :photo, dependent: :destroy
  serialize :tags
end
