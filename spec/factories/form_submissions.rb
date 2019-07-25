# frozen_string_literal: true

FactoryBot.define do
  factory :form_submission do
    form_type { "missing-book" }
    form_attributes {
      {
        attribute1: "value 1",
        attribute2: "value 2"
      }
    }
  end
end
