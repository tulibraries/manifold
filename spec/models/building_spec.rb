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
      example "missing #{f} field" do
        building = FactoryBot.build(:building)
				building[f] = ""
        expect { building.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe "field validators" do

    let(:building) { FactoryBot.build(:building) }

    context "Email validation" do
      example "valid email" do
        building.email = "chas@example.edu"
        expect { building.save! }.to_not raise_error
      end
      example "invalid email" do
        building.email = "abc"
        expect { building.save! }.to raise_error(/Email is not an email/)
      end
      example "strip email with trailing blank" do
        building.email = "chas@example.edu "
        expect { building.save! }.to_not raise_error
      end
      example "invalid email - blank " do
        building.email = ""
        expect { building.save! }.to raise_error(/Email can't be blank/)
      end
    end

    context "Phone number validation" do
      example "valid phone number" do
        building.phone_number = "2155551212"
        expect { building.save! }.to_not raise_error
      end
      example "invalid phone number" do
        building.phone_number = "215555121"
        expect { building.save! }.to raise_error(/Phone number is not a telephone number/)
      end
      example "invalid phone number - blank " do
        building.phone_number = ""
        expect { building.save! }.to raise_error(/Phone number can't be blank/)
      end
    end
  end
end
