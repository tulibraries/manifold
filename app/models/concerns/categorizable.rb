# frozen_string_literal: true

require "active_support/concern"

module Categorizable
  extend ActiveSupport::Concern
  included do
    has_many :categorizations, as: :categorizable, dependent: :destroy
    has_many :categories, through: :categorizations
  end
end
