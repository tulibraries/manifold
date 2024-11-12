# frozen_string_literal: true

Rails.application.config.after_initialize do
  default_allowed_attributes = Class.new.include(ActionText::ContentHelper).new.sanitizer_allowed_attributes
  ActionText::ContentHelper.allowed_attributes = default_allowed_attributes << "style"
end
