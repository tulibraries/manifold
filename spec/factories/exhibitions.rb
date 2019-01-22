# frozen_string_literal: true

FactoryBot.define do
  factory :exhibition do
    title { "MyString" }
    description { "MyText" }
    start_date { "2019-01-16" }
    end_date { "2019-01-16" }
  end
end
