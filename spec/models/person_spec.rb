require 'rails_helper' # ~> LoadError: cannot load such file -- rails_helper

RSpec.describe Person, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { s = FactoryBot.build(:space)
                 s.building_id = building.id
                 s.save!
                 s
  }
  let(:person) { FactoryBot.build(:person_with_groups, building_id: building.id, space_id: space.id) }

  context 'Person Class Attributes' do
    subject { Person.new.attributes.keys }

    it { is_expected.to include("first_name") }
    it { is_expected.to include("last_name") }
    it { is_expected.to include("phone_number") }
    it { is_expected.to include("email_address") }
    it { is_expected.to include("chat_handle") }
    it { is_expected.to include("job_title") }
    it { is_expected.to include("identifier") }
    it { is_expected.to include("building_id") }
    it { is_expected.to include("space_id") }
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

    required_references = [
      "building_id",
      # [TODO] Fix: missing space doesn't raise exception
      #"space_id",
    ]
    required_references.each do |f|
      example "missing #{f}" do
				person[f] = [nil]
        expect { person.save! }.to raise_error(/Validation failed:.* #{f.humanize(capitalize: true)} can't be blank/) # => 
      end
    end
  end

  describe "relation to" do
    # [TODO] Fix: Resolve the duplicate let (:person) below, without it results in 'undefined method name for nil:NilClass error'
    let (:person) { FactoryBot.create(:person_with_groups, building_id: building.id, space_id: space.id) }

    context "Group" do
      example "attach group" do
        expect(person.groups.first.name).to match(/#{Group.first.name}/)
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

