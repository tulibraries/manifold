require 'rails_helper'
require 'BuildingHelper'

RSpec.describe Building, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'Required Fields' do
    required_fields = [
      "name",
      "description",
      "address1",
      "address2",
      "temple_building_code",
      "coordinates",
      "google_id",
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
        expect { building.save! }.to raise_error(/#{I18n.t('fortytude.error.invalid_phone_format')}/)
      end
      example "invalid phone number - blank " do
        building.phone_number = ""
        expect { building.save! }.to raise_error(/#{I18n.t('fortytude.error.invalid_phone_format')}/)
      end
    end
  end
end
