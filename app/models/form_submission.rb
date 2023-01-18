# frozen_string_literal: true

class FormSubmission < ApplicationRecord
  serialize :form_attributes, JSON
  has_encrypted :form_attributes
end
