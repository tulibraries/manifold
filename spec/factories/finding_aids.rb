# frozen_string_literal: true

FactoryBot.define do
  factory :finding_aid do
    name { "MyString" }
    description { "MyText" }
    subject { ["history"] }
    content_link { "MyString" }
    identifier { "MyString" }
    drupal_id { "MyString" }
    path { "a-finding-aid" }

    factory :multi_subject_finding_aid do
      subject { ["MyString", "Another One"] }
    end
  end
end
