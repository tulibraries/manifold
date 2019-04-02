# frozen_string_literal: true

class Alert < ApplicationRecord
  has_paper_trail
  include InputCleaner

  before_validation :sanitize_description
end
