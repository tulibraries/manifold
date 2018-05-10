require 'rails_helper'

RSpec.describe Person, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

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
    let (:space) { FactoryBot.build(:space) }
    let (:building) { FactoryBot.create(:building) }

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
        person = FactoryBot.build(:person)
				person[f] = ""
        expect { person.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end

    required_references = [
      "building_id",
      "space_id",
    ]
    required_references.each do |f|
      example "missing #{f}" do
        person = FactoryBot.build(:person)
				person[f] = nil
        expect { person.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe "field validators" do

    let (:person) { FactoryBot.build(:person) }
    let (:space) { FactoryBot.build(:space) }
    let (:building) { FactoryBot.create(:building) }

    context "Email validation" do
      example "valid email" do
        person.email_address = "chas@example.edu"
        person.building_id = building.id
        person.space_id = space.id
        expect { space.save! }.to_not raise_error
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
