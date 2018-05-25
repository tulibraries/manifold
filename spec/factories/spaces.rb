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
    parent_space_id nil
  end
end
