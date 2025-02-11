# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    sequence(:title) { |n| "Prime Directive #{n}" }
    blurb { "Don't Interfere" }
    link { "https://example.com/highlight" }
    type_of_highlight { "abcdefg" }
    tags { ["abcdefg"] }
    promoted { false }
    link_label { "highlighlight label" }
    promote_to_dig_col { false }

    trait :with_image do
      after :create do |highlight|
        highlight.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
