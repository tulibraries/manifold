# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "tuz000#{n}@temple.edu" }
    password { "MyPassword" }
    admin { false }
  end

  factory :administrator, class: Account do
    sequence(:email) { |n| "tuadmin#{n}@temple.edu" }
    password { "MyPassword" }
    admin { true }
  end
end
