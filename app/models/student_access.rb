# frozen_string_literal: true

class StudentAccess < ApplicationRecord
  belongs_to :account
  belongs_to :student_accessible, polymorphic: true

  validates :account_id,
            uniqueness: { scope: [:student_accessible_type, :student_accessible_id] }
end
