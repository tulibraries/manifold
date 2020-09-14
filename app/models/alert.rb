# frozen_string_literal: true

class Alert < ApplicationRecord
  has_paper_trail
  include InputCleaner

  has_rich_text :description
end
