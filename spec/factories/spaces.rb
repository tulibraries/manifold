FactoryBot.define do
  factory :space do
    name "Map Room"
    description "Situation room where maps were consulted to track the project's progress"
    hours "Always Open"
    accessibility "Yes"
    location "Charles Samuel Addams Library"
    phone_number "2155551213"
    email "mmuffley@example.com"
    image "https://diefenbunker.files.wordpress.com/2012/05/dr-strangelove-warroom.jpg"
    association :building

    factory :space_with_people do
      after(:create) do |space|
        create_list(:person, 1, spaces: [space]) 
      end
    end

    factory :space_with_groups do
      after(:create) do |space|
        create_list(:group, 1, spaces: [space]) 
      end
    end

    factory :space_with_parent do
      after(:create) do |space|
        space.ancestry = "#{create(:space).id}"
      end
    end
  end
end
