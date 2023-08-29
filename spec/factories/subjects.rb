# frozen_string_literal: true

FactoryBot.define do
  factory :subject do
    sequence(:name) { |n| "Subject #{n}" }
  end
end
