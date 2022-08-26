# frozen_string_literal: true

FactoryBot.define do
  factory :application_failover do
    description { ActionText::Content.new("Hello World") }
    turn_on { false }
  end
end
