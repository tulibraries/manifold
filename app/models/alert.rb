# frozen_string_literal: true

class Alert < ApplicationRecord
  has_paper_trail
  has_rich_text :description

  scope :for_librarysearch, -> { where(published: true).where(for_header: true) }

end
