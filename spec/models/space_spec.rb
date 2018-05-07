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
    it { is_expected.to include("building_id") }
    it { is_expected.to include("space_id") }
  end

  context 'Required Fields' do
    example 'missing name field' do
      required_fields = [
        "name",
        "description",
        "hours",
        "accessibility",
        "location",
        "phone_number",
        "image",
        "building_id",
      ]
      required_fields.each do |f|
        space = FactoryBot.build(:space)
				space[f] = ""
        expect { space.save! }.to raise_error("Validation failed: #{f.humanize(capitalize: true)} can't be blank")
      end
    end
  end
end

