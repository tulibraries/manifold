# frozen_string_literal: true

class SubjectSpecialty < ApplicationRecord
  belongs_to :person
  belongs_to :subject
end
