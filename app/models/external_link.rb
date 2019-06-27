# frozen_string_literal: true

class ExternalLink < ApplicationRecord
  has_paper_trail
  include Validators
  include Categorizable

  validates :title, presence: true
  validates :link, presence: true, url: true

  def label
    title
  end
end
