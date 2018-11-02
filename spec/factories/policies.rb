# frozen_string_literal: true

FactoryBot.define do
  factory :policy do
    sequence(:name) { |n| "Policy #{n}" }
    description {
      <<~EOD.strip.gsub(/\n/, " ")
      No dogs allowed,
      You're not our crowd,
      Obey the signs,
      And boundary lines.
      EOD
    }
    effective_date { "2018-10-29" }
    expiration_date { "2018-10-29" }
  end
end
