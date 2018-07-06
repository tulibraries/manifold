require 'rails_helper' # ~> LoadError: cannot load such file -- rails_helper

RSpec.describe Person, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, buildings: [building], spaces: [space]) }

  context 'Person Class Attributes' do
    subject { Person.new.attributes.keys }

    it { is_expected.to include("first_name") }
    it { is_expected.to include("last_name") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("email_address") }
    it { is_expected.to include("chat_handle") }
    it { is_expected.to include("job_title") }
    it { is_expected.to include("identifier") }
  end

  context 'Required Fields' do

    required_fields = [
      "first_name",
      "last_name",
      "phone_number",
      "chat_handle",
      "email_address",
      "job_title",
    ]
    required_fields.each do |f|
      example "missing #{f} fields" do
				person[f] = ""
        expect { person.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe "relation to" do
    let(:group) { FactoryBot.create(:group, buildings: [building], spaces: [space]) }
    let(:person) { FactoryBot.create(:person, groups: [group], buildings: [building], spaces: [space]) }
    context "Group" do
      example "attach group" do
        expect(person.groups.first.name).to match(/#{Group.first.name}/)
      end
    end
  end

  describe "required relations" do
    context "Building" do
      example "attach building" do
        person = FactoryBot.create(:person, buildings: [building], spaces: [space]) 
        expect { person.save! }.to_not raise_error
        expect(person.buildings.first.name).to match(/#{Building.first.name}/)
      end
      example "no building" do
        person = FactoryBot.build(:person, spaces: [space]) 
        expect { person.save! }.to raise_error(/Buildings can't be blank/)
      end
    end
    context "Space" do
      example "attach space" do
        person = FactoryBot.create(:person, buildings: [building], spaces: [space]) 
        expect { person.save! }.to_not raise_error
        expect(person.buildings.first.name).to match(/#{Building.first.name}/)
      end
      example "no space" do
        person = FactoryBot.build(:person, buildings: [building]) 
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
end

