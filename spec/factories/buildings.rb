# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :building do
    sequence(:name) { |n| "Charles Samuel Addams Library %03d" % n }
    description { ActionText::Content.new("Hello World") }
    address1 { "1250 Polett Walk" }
    city { "Philadelphia" }
    state { "PA" }
    zipcode { "19122" }
    coordinates { "test,coordinated" }
    google_id { "12345678910azby-kk" }
    hours { "" }
    phone_number { "2155551212" }
    email { "csa@example.edu" }

    factory :building_with_people do
      after(:create) do |building|
        create_list(:person, 1, buildings: [building])
      end
    end

    factory :building_with_groups do
      after(:create) do |building|
        create_list(:group, 1, buildings: [building])
      end
    end
  end

end
