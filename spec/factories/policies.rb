# frozen_string_literal: true

FactoryBot.define do
  factory :policy do
    sequence(:name) { |n| "Prime Directive #{n}" }
    description { "Don't Interfere" }
    effective_date { Date.new(2001, 1, 1) }
    expiration_date { Date.new(2001, 1, 2) }
    category { ["Conduct"] }
  end
end
