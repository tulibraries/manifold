require 'rails_helper'

RSpec.describe Group, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

  context 'Group Class Attributes' do
    subject { Group.new.attributes.keys }

    it { is_expected.to include("name") }
    it { is_expected.to include("description") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("email_address") }

  end

  describe "has many through member" do
    context "Attach person" do
      let(:group) { FactoryBot.create(:group, persons: [person], buildings: [building], spaces: [space]) }
      example "valid" do
        expect(group.persons.last.last_name).to match(/#{Person.last.last_name}/)
        expect(group.persons.last.first_name).to match(/#{Person.last.first_name}/)
      end
    end

    context "No person" do
      let(:group) { FactoryBot.create(:group, buildings: [building], spaces: [space]) }
      example "valid" do
        expect {group.save!}.to_not raise_error 
      end
    end
  end

  describe "has many buildings through" do
    context "Attach building" do
      let(:group) { FactoryBot.create(:group, persons: [person], buildings: [building], spaces: [space]) }
      example "valid" do
        expect {group.save!}.to_not raise_error 
        expect(group.buildings.last.name).to match(/#{Building.last.name}/)
      end
    end
  end

  describe "has many spaces through" do
    context "Attach space" do
      let(:group) { FactoryBot.create(:group, persons: [person], buildings: [building], spaces: [space]) }
      example "valid" do
        expect {group.save!}.to_not raise_error 
        expect(group.spaces.last.name).to match(/#{Space.last.name}/)
      end
    end
  end


  describe "field validators" do
    let(:group) { FactoryBot.build(:group, buildings: [building], spaces: [space]) }
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
        group = FactoryBot.create(:group, buildings: [building], spaces: [space]) 
        expect { group.save! }.to_not raise_error
      end
      example "no building" do
        group = FactoryBot.build(:group, spaces: [space]) 
        expect { group.save! }.to raise_error(/Buildings can't be blank/)
      end
    end

    context "Space reference" do
      example "valid space ID" do
        expect { group.save! }.to_not raise_error
      end
      example "No space" do
        group = FactoryBot.build(:group, buildings: [building]) 
        expect { group.save! }.to raise_error(/Spaces can't be blank/)
      end
    end
  end
end
