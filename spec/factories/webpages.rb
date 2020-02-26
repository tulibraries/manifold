# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "MyString" }
    description { "MyText" }
    layout { "MyLayout" }
  end
end
