namespace :db do # ~> NoMethodError: undefined method `namespace' for main:Object
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populate'
    require 'faker'
    
    [Building, Space, Group, Person].each(&:delete_all)

    def fake_email
      Faker::Internet.user_name + "@temple.edu"
    end

    for b in 1..6 do
      building = Building.create!(
        name:                 Faker::Name.name_with_middle + " Library",
        description:          Faker::Lorem.paragraph,
        address1:             Faker::Address.street_address,
        temple_building_code: Faker::Address.building_number,
        directions_map:       Faker::File.file_name('images/maps', 'tubldg', 'jpg'),
        hours:                "0800-2100",
        phone_number:         Faker::Number.number(10),
        image:                Faker::File.file_name('images', 'tubldg', 'jpg'),
        campus:               Faker::Address.community,
        accessibility:        "Yes",
        email:                fake_email)

      for s in 1..10 do
        space = Space.create!(
          name:            "Room " + Faker::Number.number(2) + "0",
          description:     Faker::Lorem.paragraph,
          hours:           "0800-2100",
          accessibility:   "Yes",
          email:           fake_email,
          location:        Faker::Lorem.sentence,
          phone_number:    Faker::Number.number(10),
          image:           Faker::File.file_name('images', 'tubldg', 'jpg'),
          #parent_space_id: 0,
          building_id:     building.id)
      end
    end

    for p in 1..10 do
      person = Person.create!(
        first_name:    Faker::Name.first_name,
        last_name:     Faker::Name.last_name,
        phone_number:  Faker::Number.number(10),
        email_address: fake_email,
        chat_handle:   Faker::Twitter.screen_name,
        job_title:     Faker::Job.title,
        identifier:    "TU" + Faker::Number.number(6),
        space_id:      Space.order("RANDOM()").first.id)

        building_person = BuildingsPeople.create!(
          person_id:   person.id,
          building_id: Building.order("RANDOM()").first.id)
    end

    for g in 1..10 do
      group = Group.create!(
        name:          Faker::Job.field,
        description:   Faker::Lorem.paragraph,
        phone_number:  Faker::Number.number(10),
        email_address: fake_email,
        building_id:   Building.order("RANDOM()").first.id,
        space_id:      Space.order("RANDOM()").first.id)

      membership = Membership.create!(
        group_id:  group.id,
        person_id: Person.order("RANDOM()").first.id)
    end
  end
end

