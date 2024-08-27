# frozen_string_literal: true

FactoryBot.define do
  factory :form_info do
    title { "Form Information" }
    slug { "form-information" }
    recipients { ["test@test.com"] }
    grouping { nil }
    enabled { true }

    trait :no_recipient do
      recipients { [""] }
    end

    trait :disabled do
      enabled{ false }
    end
  end
end
