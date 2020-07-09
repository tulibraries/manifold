# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    scroll_text { "This is an alert" }
    link { "http://library.temple.edu" }
    description { "thjis is a test alert" }
    published { true }

    trait :unpublished do
        published { false }
      end
  end
end
