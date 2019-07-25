# frozen_string_literal: true

class FormSubmission < ApplicationRecord
  serialize :form_attributes, JSON
  encrypts :form_attributes
end
