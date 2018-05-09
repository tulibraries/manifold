require 'rails_helper'

RSpec.describe Space, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'Space Class Attributes' do
    subject { Space.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("hours") }
    it { is_expected.to include("accessibility") }
    it { is_expected.to include("location") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("image") }
    it { is_expected.to include("email") }
    it { is_expected.to include("building_id") }
    it { is_expected.to include("space_id") }
  end

  context 'Required Fields' do
    required_fields = [
      "name",
      "description",
      "hours",
      "accessibility",
      "location",
      "image",
    ]
    required_fields.each do |f|
      example "missing #{f} fields" do
        space = FactoryBot.build(:space)
				space[f] = ""
        expect { space.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end

    required_references = [
      "building_id",
    ]
    required_references.each do |f|
      example "missing #{f}" do
        space = FactoryBot.build(:space)
				space[f] = nil
        expect { space.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  context "Email validation" do
    let (:space) { FactoryBot.build(:space) }
    let (:building) { FactoryBot.create(:building) }
    example "valid email" do
      space.email = "chas@example.edu"
      space.building_id = building.id
      expect { space.save! }.to_not raise_error
    end
    example "invalid email" do
      space.email = "abc"
      expect { space.save! }.to raise_error(/Email is not an email/)
    end
    example "invalid email - blank " do
      space.email = ""
      expect { space.save! }.to raise_error(/Email can't be blank/)
    end
  end

  context "Phone number validation" do
    let (:space) { FactoryBot.build(:space) }
    let (:building) { FactoryBot.create(:building) }
    example "valid phone number" do
      space.building_id = building.id
      space.phone_number = "2155551212"
      expect { space.save! }.to_not raise_error
    end
    example "invalid phone number" do
      space.phone_number = "215555121"
      expect { space.save! }.to raise_error(/Phone number is not a telephone number/)
    end
    example "invalid phone number - blank " do
      space.phone_number = ""
      expect { space.save! }.to raise_error(/Phone number can't be blank/)
    end
  end

  context "Building reference" do
    let (:space) { FactoryBot.build(:space) }
    let (:building) { FactoryBot.create(:building) }
    example "valid building" do
      space.building_id = building.id
      expect { space.save! }.to_not raise_error
    end
    example "invalid building" do
      space.building_id = building.id + 1
      expect { space.save! }.to raise_error(/Building reference is invalid/)
    end
  end
end

