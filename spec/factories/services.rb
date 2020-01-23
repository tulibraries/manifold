# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:title) { |n| "The Service #{n}" }
    description {
    <<~EOD.strip.gsub(/\n/, " ")
      The best drink in existence is the Pan Galactic Gargle Blaster, the effect
      of which is like having your brains smashed out by a slice of lemon wrapped
      round a large gold brick.
    EOD
  }
    access_description { "Fully accessible" }
    service_policies { "Plenary" }
    intended_audience { ["General"] }
    hours { "hours" }
  end
end
