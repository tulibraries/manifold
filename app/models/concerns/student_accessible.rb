# frozen_string_literal: true

require "active_support/concern"

module StudentAccessible
  extend ActiveSupport::Concern

  included do
    has_many :student_accesses, as: :student_accessible, dependent: :destroy
    has_many :student_access_accounts, through: :student_accesses, source: :account
  end
end
