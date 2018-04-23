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
        "phone_number",
        "image",
        "campus",
        "accessibility",
        "email"
      ]
      required_fields.each do |f|
        @building = FactoryBot.build(:building)
				@building[f] = ""
        expect { @building.save! }.to raise_error("Validation failed: #{f.humanize(capitalize: true)} can't be blank")
      end
    end
  end

end
