# frozen_string_literal: true

class Alert < ApplicationRecord
  include InputCleaner

  before_validation :sanitize_description
end
