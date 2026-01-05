# frozen_string_literal: true

class StudentAccessAccountsField < Administrate::Field::HasMany
  private

  def candidate_resources
    associated_class.student
  end
end
