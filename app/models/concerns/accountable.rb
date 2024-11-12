# frozen_string_literal: true

require "active_support/concern"

module Accountable
  extend ActiveSupport::Concern
  included do
    has_many :accountabilities, as: :accountable, dependent: :destroy
    has_many :accounts, through: :accountabilities
    alias_method :individual_owners, :accounts
  end
end
