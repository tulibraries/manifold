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
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("image") }
    it { is_expected.to include("email") }
    it { is_expected.to include("building_id") }
    it { is_expected.to include("ancestry") }
  end

  context 'Required Fields' do
    required_fields = [
      "name",
      "description",
      "hours",
      "accessibility",
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
        expect { space.save! }.to raise_error(/#{f.humanize(capitalize: true)} must exist/)
      end
    end
  end

  context "Optional Fields" do
    optional_references = [
      "ancestry",
    ]
    optional_references.each do |f|
      example "missing #{f}" do
        space = FactoryBot.build(:space_with_building)
				space[f] = nil
        expect { space.save! }.to_not raise_error
      end
    end
  end

  describe "field validators" do

    let (:space) { FactoryBot.build(:space_with_building) }

    context "Email validation" do
      example "valid email" do
        space.email = "chas@example.edu"
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
      example "valid phone number" do
        space.phone_number = "2155551212"
        expect { space.save! }.to_not raise_error
      end
      example "invalid phone number" do
        space.phone_number = "215555122"
        expect { space.save! }.to raise_error(/Phone number is not a telephone number/)
      end
      example "invalid phone number - blank " do
        space.phone_number = ""
        expect { space.save! }.to raise_error(/Phone number can't be blank/)
      end
    end

    context "Building reference" do
      example "valid building" do
        expect { space.save! }.to_not raise_error
      end
      example "no building" do
        space = FactoryBot.build(:space)
        expect { space.save! }.to raise_error(/Building can't be blank/)
      end
    end

    context "Optional parent space reference" do
      example "no space ID" do
        space.parent = nil
        expect { space.save! }.to_not raise_error
      end
      example "valid space ID" do
        space = FactoryBot.build(:space_with_parent)
        expect { space.save! }.to_not raise_error
      end
    end
  end
end
