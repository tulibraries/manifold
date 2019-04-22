# frozen_string_literal: true

class Exhibition < ApplicationRecord
  has_paper_trail
  include InputCleaner
  include Categorizable
  include Imageable

  belongs_to :group, optional: true
  belongs_to :space, optional: true
  belongs_to :collection, optional: true

  before_save :sanitize_description
end
