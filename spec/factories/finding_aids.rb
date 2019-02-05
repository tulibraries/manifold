# frozen_string_literal: true

FactoryBot.define do
  factory :finding_aid do
    name { "MyString" }
    description { "MyText" }
    subject { "MyString" }
    content_link { "MyString" }
    identifier { "MyString" }
  end
end
