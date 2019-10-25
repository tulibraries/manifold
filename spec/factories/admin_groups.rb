# frozen_string_literal: true

FactoryBot.define do
  factory :admin_group do
    name { "Admin Group Name" }
    members { [] }
  end
end
