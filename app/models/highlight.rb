# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Imageable
  has_paper_trail

  serialize :tags
end
