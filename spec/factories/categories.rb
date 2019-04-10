# frozen_string_literal: true


FactoryBot.define do
  factory :category do
    name { "Dreaming" }

    trait :custom_url do
      custom_url { "http://sand.man" }
    end

    trait :with_icon do
      after :create do |category|
        file_path = Rails.root.join("spec", "fixtures", "dream.jpg")
        file = fixture_file_upload(file_path, "image/jpeg")
        category.icon.attach(file)
      end
    end
    factory :category_parent do
      name { "Dreaming while Dreaming" }
    end
  end


end
