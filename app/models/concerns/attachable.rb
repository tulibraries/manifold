# frozen_string_literal: true

require "active_support/concern"

module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :fileabilities, as: :attachable, dependent: :destroy
    has_many :file_uploads, through: :fileabilities, dependent: :destroy

    accepts_nested_attributes_for :fileabilities
  end
end
