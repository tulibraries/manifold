FactoryBot.define do
  factory :building do
    sequence(:name) { |n| "Charles Samuel Addams Library #{n}" }
    description "Main Campus Main Library"
    address1 "1250 Polett Walk"
    temple_building_code "ABC"
    directions_map "http://maps.exammple.edu/CSA.jpg"
    hours "Always Open"
    phone_number "2155551212"
    image "https://i.pinimg.com/736x/c8/51/2f/c8512fd8b92570627bbd35f44171d44d.jpg"
    campus "Main Campus"
    accessibility "Yes"
    email "csa@example.edu"

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
