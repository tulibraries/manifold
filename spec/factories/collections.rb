# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    sequence(:name) { |n| "Collection #{ n }" }
    description {
      <<~EOD.strip.gsub(/\n/, " ")
        The best drink in existence is the Pan Galactic Gargle Blaster, the effect
        of which is like having your brains smashed out by a slice of lemon wrapped
        round a large gold brick.
      EOD
    }
    subject { ["MyText"] }
    contents { "MyText" }
    add_to_footer { false }

    categories { [] }

    association :space
    finding_aids { [] }

    trait :with_image do
      after :create do |collection|
        file_path = Rails.root.join("spec/fixtures/charles.jpg")
        file = fixture_file_upload(file_path, "image/png")
        collection.image.attach(file)
      end
    end
  end
end
