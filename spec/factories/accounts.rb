# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    email { "tuz12345@temple.edu" }
    password { "MyPassword" }
    admin { false }
  end
end
