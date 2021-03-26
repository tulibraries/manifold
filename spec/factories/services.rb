# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:title) { "Printing" }
    description { ActionText::Content.new("Hello World") }
    access_description { ActionText::Content.new("Goodbye, Cruel World") }
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
