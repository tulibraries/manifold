# frozen_string_literal: true

FactoryBot.define do
  factory :form_info do
    title { "Form Information" }
    slug { "form-information" }
    recipients { ["test@test.com"] }

    trait :no_recipient do
      recipients { [""] }
    end
  end
end
