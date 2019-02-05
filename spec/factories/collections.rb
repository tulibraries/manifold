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

    association :space
    # association :finding_aid
  end
end
