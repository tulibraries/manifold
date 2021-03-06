# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "#{(0...3).map { (65 + rand(26)).chr }.join}000#{n}@temple.edu" }
    password { "MyPassword" }
    sequence(:name) { |n| "My Name #{n}" }
    admin { false }
  end

  factory :administrator, class: Account do
    sequence(:email) { |n| "#{(0...3).map { (65 + rand(26)).chr }.join}admin#{n}@temple.edu" }
    password { "MyPassword" }
    sequence(:name) { |n| "My Name #{n}" }
    admin { true }
  end
end
