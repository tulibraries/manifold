# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Photographable
  has_paper_trail

  has_one_attached :image, dependent: :destroy
  serialize :tags
end
