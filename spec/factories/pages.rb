# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { "MyString" }
    description { "MyText" }
    layout { "MyLayout" }
  end
end
