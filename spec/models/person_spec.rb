# frozen_string_literal: true

require "rails_helper" # ~> LoadError: cannot load such file -- rails_helper

RSpec.describe Person, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:chair_person) { FactoryBot.build(:person, spaces: [space]) }

  describe "relation to" do
    let(:group) { FactoryBot.create(:group, chair_dept_head: chair_person, spaces: [space]) }
    let(:person) { FactoryBot.create(:person, groups: [group], spaces: [space]) }
    context "Group" do
      example "attach group" do
        expect(person.groups.first.name).to match(/#{Group.first.name}/)
      end
    end
  end

  describe "Required fields" do
    example "Person must have a last name" do
      person = FactoryBot.build(:person, last_name: "", spaces: [space])
      expect { person.save! }.to raise_error(/Last name can't be blank/)
    end
    example "Person must have a first name" do
      person = FactoryBot.build(:person, first_name: "", spaces: [space])
      expect { person.save! }.to raise_error(/First name can't be blank/)
    end
  end

  describe "required relations" do
    context "Space" do
      example "attach space" do
        person = FactoryBot.create(:person, spaces: [space])
        expect { person.save! }.to_not raise_error
        expect(person.spaces.first.name).to match(/#{Space.first.name}/)
      end
      example "no space" do
        person = FactoryBot.build(:person)
        person.spaces = []
        expect { person.save! }.to raise_error(/Spaces can't be blank/)
      end
    end
  end

  describe "field validators" do
    context "Email validation" do
      example "valid email" do
        person.email_address = "chas@example.edu"
        expect { person.save! }.to_not raise_error
      end
      example "invalid email" do
        person.email_address = "abc"
        expect { person.save! }.to raise_error(/Email address is not an email/)
      end
      example "invalid email - blank " do
        person.email_address = ""
        expect { person.save! }.to raise_error(/Email address can't be blank/)
      end
    end
  end

  describe "show name" do
    example "with first and last name" do
      person = FactoryBot.create(:person, spaces: [space])
      expect(person.name).to match(/Zaphod Beeblebrox/)
    end
  end
end
