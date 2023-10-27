# frozen_string_literal: true

FactoryBot.define do
  factory :form do
    name { "Form Name" }
    email { "form-email" }
    recipients { ["test@test.com"].to_json }

    trait :no_name do
      name {}
    end

    trait :no_email do
      email {}
    end
  end
end
