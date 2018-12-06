# frozen_string_literal: true

require "rails_helper"

RSpec.describe LibraryHours, type: :model do

  let(:library_hour) { FactoryBot.create(:library_hour) }

  describe "Required fields" do
    example "Library Hour must have a location_id" do
      hour = FactoryBot.build(:library_hour, location_id: "")
      expect { hour.save! }.to raise_error(/Location can't be blank/)
    end
    example "Library Hour must have a date" do
      hour = FactoryBot.build(:library_hour, date: "")
      expect { hour.save! }.to raise_error(/Date can't be blank/)
    end
    example "Library Hour must have hours" do
      hour = FactoryBot.build(:library_hour, hours: "")
      expect { hour.save! }.to raise_error(/Hours can't be blank/)
    end
  end
end
