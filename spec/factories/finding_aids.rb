# frozen_string_literal: true

FactoryBot.define do
  factory :finding_aid do
    name { "finding aid" }
    holdover { false }
    description { ActionText::Content.new("Hello World") }
    subject { ["history"] }
    content_link { "content_link" }
    identifier { "identifier" }
    drupal_id { "drupal_id" }
    path { "a-finding-aid" }

    factory :multi_subject_finding_aid do
      subject { ["subject 1", "subject 2"] }
    end
  end
end
