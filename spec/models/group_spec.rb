require 'rails_helper'

RSpec.describe Group, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  let (:person) { p = FactoryBot.build(:person)
                  p.building_id = building.id
                  p.space_id = space.id
                  p.save!
                  p
  }
  let (:group) { b = FactoryBot.create(:building)

                 s = FactoryBot.build(:space)
                 s.building_id = b.id
                 s.save!

                 g = FactoryBot.build(:group)
                 g.building_id = b.id
                 g.space_id = s.id
                 g
  }

  context 'Group Class Attributes' do
    subject { Group.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("email_address") }
    it { is_expected.to include("building_id") }
    it { is_expected.to include("space_id") }

  end

  context 'Required Fields' do

    required_fields = [
      "name",
      "description",
      "phone_number",
      "email_address"
    ]
    required_fields.each do |f|
      example "missing #{f} fields" do
				group[f] = ""
        expect { group.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end

    required_references = [
      "building_id",
      "space_id",
    ]
    required_references.each do |f|
      example "missing #{f}" do
				group[f] = nil
        expect { group.save! }.to raise_error(/Validation failed:.* #{f.humanize(capitalize: true)} must exist/)
      end
    end
  end

  describe "field validators" do
    context "Email validation" do
      example "valid email", focus: true do
        group.email_address = "we@example.edu"
        expect { group.save! }.to_not raise_error
      end
      example "invalid email" do
        group.email_address = "abc"
        expect { group.save! }.to raise_error(/Email address is not an email/)
      end
      example "invalid email - blank " do
        group.email_address = ""
        expect { group.save! }.to raise_error(/Email address can't be blank/)
      end
    end

    context "Phone number validation" do
      example "valid phone number" do
        group.phone_number = "2155551213"
        expect { group.save! }.to_not raise_error
      end
      example "invalid phone number" do
        group.phone_number = "215555122"
        expect { group.save! }.to raise_error(/Phone number is not a telephone number/)
      end
      example "invalid phone number - blank " do
        group.phone_number = ""
        expect { group.save! }.to raise_error(/Phone number can't be blank/)
      end
    end

    context "Building reference" do
      example "valid building" do
        expect { group.save! }.to_not raise_error
      end
      example "invalid building" do
        group.building_id += 100
        expect { group.save! }.to raise_error(/Building reference is invalid/)
      end
    end

    context "Space reference" do
      example "no space ID" do
        group.space_id = nil
        expect { group.save! }.to raise_error(/Space must exist/)
      end
      example "valid space ID" do
        expect { group.save! }.to_not raise_error
      end
      example "invalid space ID" do
        group.space_id = -1
        expect { group.save! }.to raise_error(/Space reference is invalid/)
      end
    end
  end
end
