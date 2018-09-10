require 'rails_helper'

RSpec.describe LibraryHours, type: :model do
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'Required Fields' do
    required_fields = [
      "location",
      "date",
      "hours",
      "location_id",
    ]
    required_fields.each do |f|
      example "missing #{f} field" do
        # skip "Need to implement presence validation for `#{f}`" if ["description"].include?(f)
        library_hours = FactoryBot.build(:library_hours)
				library_hours[f] = ""
        expect { library_hours.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end
end