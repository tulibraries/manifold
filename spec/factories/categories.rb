# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { "Dreaming" }
    custom_url { "" }
    description { "" }
    long_description { "Extended explanation" }
    get_help { "" }

    trait :custom_url do
      custom_url { "http://sand.man" }
    end

    trait :with_image do
      after :create do |category|
        category.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
    factory :category_parent do
      name { "Dreaming while Dreaming" }
    end
    trait :with_description do
      description { "It's what the category is about" }
    end
    trait :with_long_description do
      long_description { "It's more about what the category is about" }
    end
    trait :with_get_help do
      get_help { "It's what help is for" }
    end
  end

end
