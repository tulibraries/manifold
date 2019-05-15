# frozen_string_literal: true

FactoryBot.define do
  factory :external_link do
    title { "MyString" }
    link { "https://example.org" }

    factory :external_link_bad_url do
      link { "not://a:url" }
    end
  end
end
