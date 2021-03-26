# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    scroll_text { "This is an alert" }
    link { "http://library.temple.edu" }
    description { ActionText::Content.new("Hello World") }
    published { true }

    trait :unpublished do
        published { false }
      end
  end
end
