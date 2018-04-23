require 'rails_helper'

RSpec.describe Building, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'Building Class Attributes' do
    subject { Building.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("address1") }
    it { is_expected.to include("temple_building_code") }
    it { is_expected.to include("directions_map") }
    it { is_expected.to include("hours") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("image") }
    it { is_expected.to include("campus") }
    it { is_expected.to include("accessibility") }
    it { is_expected.to include("email") }
  end

  context 'Required Fields' do
    example 'missing name field' do
      required_fields = [
        "name",
        "description",
        "address1",
        "temple_building_code",
        "directions_map",
        "hours",
        "image",
        "campus",
        "accessibility",
      ]
      required_fields.each do |f|
        building = FactoryBot.build(:building)
				building[f] = ""
        expect { building.save! }.to raise_error("Validation failed: #{f.humanize(capitalize: true)} can't be blank")
      end
    end
  end

  context 'Email validation' do
    example 'valid email' do
      building = FactoryBot.build(:building)
      building.email = "chas@example.edu"
      expect { building.save! }.to_not raise_error
    end
    example 'invalid email' do
      building = FactoryBot.build(:building)
      building.email = "abc"
      expect { building.save! }.to raise_error("Validation failed: Email is not an email")
    end
    example 'invalid email - blank ' do
      building = FactoryBot.build(:building)
      building.email = ""
      expect { building.save! }.to raise_error("Validation failed: Email can't be blank, Email is not an email")
    end
  end

  context 'Phone number validation' do
    example 'valid phone number' do
      building = FactoryBot.build(:building)
      building.phone_number = "2155551212"
      expect { building.save! }.to_not raise_error
    end
    example 'invalid phone number' do
      building = FactoryBot.build(:building)
      building.phone_number = "215555121"
      expect { building.save! }.to raise_error("Validation failed: Phone number is not a telephone number")
    end
    example 'invalid phone number - blank ' do
      building = FactoryBot.build(:building)
      building.phone_number = ""
      expect { building.save! }.to raise_error("Validation failed: Phone number can't be blank, Phone number is not a telephone number")
    end
  end
end
