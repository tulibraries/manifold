# frozen_string_literal: true

namespace :db do # ~> NoMethodError: undefined method `namespace' for main:Object
  namespace :populate do
    require "populate"
    require "faker"

    task policies: :environment do
      Policy.delete_all

      for p in 1..5 do
        effective_date = Faker::Date.between("2018-01-01", "2018-06-01")
        if Faker::Boolean.boolean
          policy = Policy.create!(
            name:            Faker::HitchhikersGuideToTheGalaxy.specie,
            description:     Faker::HitchhikersGuideToTheGalaxy.quote,
            effective_date:  effective_date,
            expiration_date: effective_date + 1 + rand(365),
          )
        else
          policy = Policy.create!(
            name:           Faker::HitchhikersGuideToTheGalaxy.specie,
            description:    Faker::HitchhikersGuideToTheGalaxy.quote,
            effective_date: effective_date,
          )
        end
      end
    end

    task all: :environment do

      [ServiceGroup,
       ServiceSpace,
       Service,
       Occupant,
       SpaceGroup,
       Member,
       GroupContact,
       Event,
       Building,
       Space,
       Group,
       Person].each(&:delete_all)


      def fake_email
        Faker::Internet.user_name + "@temple.edu"
      end

      for b in 1..6 do
        building = Building.create!(
          name:                 Faker::Name.name_with_middle + " Library",
          description:          Faker::Lorem.paragraph,
          address1:             Faker::Address.street_address,
          address2:             Faker::Address.street_address,
          temple_building_code: Faker::Address.building_number,
          coordinates:          "blip",
          google_id:            "bleep",
          hours:                "0800-2100",
          phone_number:         Faker::Number.number(10),
          campus:               Faker::Address.community,
          email:                fake_email)

        for s in 1..4 do
          space = Space.create!(
            name:            "Room " + Faker::Number.number(2) + "0",
            description:     Faker::Lorem.paragraph,
            hours:           "0800-2100",
            accessibility:   "Yes",
            email:           fake_email,
            phone_number:    Faker::Number.number(10),
            building:        building,
            image:           Faker::File.file_name("images", "tubldg", "jpg"))
        end
        for s in 1..2 do
          space = Space.create!(
            name:            "Room " + Faker::Number.number(2) + "0",
            description:     Faker::Lorem.paragraph,
            hours:           "0800-2100",
            accessibility:   "Yes",
            email:           fake_email,
            phone_number:    Faker::Number.number(10),
            image:           Faker::File.file_name("images", "tubldg", "jpg"),
            parent:          Space.all.sample,
            building:        building)
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
          research_identifier:    "TU" + Faker::Number.number(6),
          spaces:        [Space.all.sample])
      end

      for g in 1..5 do
        group = Group.create!(
          name:          Faker::Job.field,
          description:   Faker::Lorem.paragraph,
          phone_number:  Faker::Number.number(10),
          email_address: fake_email,
          group_type:    Rails.configuration.group_types.sample,
          chair_dept_heads: [Person.all.sample],
          external:      [false, true].sample,
          persons:       Person.all.sample(rand(Person.count)),
          space:        Space.all.sample)
      end


      for e in 1..5 do
        event = Event.create!(
          title:                Faker::Lorem.sentence(1 + rand(4)),
          description:          Faker::Lorem.paragraph,
          start_time:           "2018-09-24 11:32:13", #Faker::DateTime.dateTimeBetween($startDate = 'now', $endDate = 'tomorrow', $timezone = null),
          end_time:             "2018-09-24 11:32:13", #Faker::DateTime.dateTimeBetween($startDate = 'now', $endDate = 'tomorrow', $timezone = null),
          building:             Building.all.sample,
          space:                Space.all.sample,
          person:               Person.all.sample,
          cancelled:            [false, true].sample,
          registration_status:  [false, true].sample)
      end

      for v in 1..5 do
        service = Service.create!(
          title:              Faker::Job.field,
          description:        Faker::Lorem.paragraph,
          access_description: Faker::Lorem.paragraph,
          service_policies:   Faker::Lorem.paragraph,
          intended_audience:  Rails.configuration.audience_types.sample(rand(1..Rails.configuration.audience_types.count)),
          service_category:   Rails.configuration.service_types.sample,
          related_groups:     Group.all.sample(rand(1..Group.count)),
          related_spaces:     Space.all.sample(rand(Space.count)))
      end
    end
  end
end
