# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    first_name { "Zaphod" }
    sequence(:last_name) { |n| "Beeblebrox #{n}" }
    phone_number { "2155551213" }
    email_address { "zbeeblebrox@example.com" }
    chat_handle { "zbeeblebrox" }
    job_title { "President of the Galaxy" }
    research_identifier { "PREZBEEB" }
    personal_site { "http://prez.example.com" }
    springshare_id { "0123-4567-8901" }
    # Add related objects in create.
    # e.g.
    #   let(:building) { FactoryBot.create(:building) }
    #   let(:space) { FactoryBot.create(:space, building: building) }
    #   let(:person) { FactoryBot.create(:person, spaces: [space]) }
  end
end
