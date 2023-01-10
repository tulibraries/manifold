# frozen_string_literal: true

FactoryBot.define do
  factory :snippet do
    title { "MyString" }
    description { ActionText::Content.new("Hello World") }
    slug { "mystring" }
  end
end
