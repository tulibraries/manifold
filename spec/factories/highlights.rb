# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    title { "MyString" }
    blurb { "MyText" }
    link { "MyString" }
    type_of_highlight { "" }
    tags { "MyString" }
    photo { "photo" }
  end
end
