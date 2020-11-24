# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:title) { "Printing" }
    description {
    <<~EOD.strip.gsub(/\n/, " ")
      The best drink in existence is the Pan Galactic Gargle Blaster.
    EOD
  }
    access_description { "Fully accessible" }
    intended_audience { ["General"] }
    hours { "hours" }
  end
  factory :service_static, class: Service do
    title { "Service Static" }
    description { ActionText::Content.new("The best drink in existence is the Pan Galactic Gargle Blaster.") }
    access_description { ActionText::Content.new("Fully accessible") }
    intended_audience { ["General"] }
    hours { "hours" }
  end
end
