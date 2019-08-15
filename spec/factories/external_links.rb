# frozen_string_literal: true

FactoryBot.define do
  factory :external_link do
    title { "MyString" }
    link { "https://example.org" }

    factory :external_link_internal_path do
      title { "Internal Path" }
      link { "/path/to/thing" }
    end
  end
end
