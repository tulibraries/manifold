# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    title { "MyString" }
    blurb { "MyText" }
    link { "MyString" }
    date { "2018-09-14" }
    time { "2018-09-14 17:10:23" }
    type_of_highlight { "" }
    tags { "MyString" }
    photo { "photo" }
  end
end
