# frozen_string_literal: true

require "active_support/concern"

module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :fileabilities, as: :attachable, dependent: :destroy
    has_many :file_uploads, through: :fileabilities

    accepts_nested_attributes_for :fileabilities, allow_destroy: true
  end
end
