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
  end
end
