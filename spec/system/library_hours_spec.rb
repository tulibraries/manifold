# frozen_string_literal: true

require "rails_helper"

RSpec.describe "LibraryHours", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Edge Tests" do
    before do
      @buildings = [
        {
          slug: "charles",
          spaces: [ "charles" ]
        }
      ]
      @hour = FactoryBot.create(:library_hour, date: Time.zone.parse("2000-01-01"), hours: "8:00 am - 10:00 pm",  location_id: "charles")
    end

    scenario "hours outside bounds of database" do

      expect {
        visit("/hours?date=2000-01-01")
      }.to_not raise_error
    end
  end
end
