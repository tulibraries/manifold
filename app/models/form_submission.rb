# frozen_string_literal: true

class FormSubmission < ApplicationRecord
  store :form_attributes, coder: JSON
  has_encrypted :form_attributes
end
