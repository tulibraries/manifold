# frozen_string_literal: true

require "active_support/concern"

module Draftable
  extend ActiveSupport::Concern
  included do
    # Virtual form attriibute indicating to apply drafts to entity
    attr_accessor :publish
  end
end
