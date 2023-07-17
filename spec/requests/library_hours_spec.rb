# frozen_string_literal: true

require "rails_helper"

RSpec.describe "LibraryHours", type: :request do

  describe "/hours" do
    let(:hour) { FactoryBot.create(:library_hour) }
    let(:hour1) { FactoryBot.create(:library_hour, location_id: "online") }
    let(:hour2) { FactoryBot.create(:library_hour, location_id: "scrc") }
    @buildings = [
      {
        slug: "online",
        spaces: ["ask_a_librarian"]
      },
      {
        slug: "ambler",
        spaces: ["ambler"]
      },
      {
        slug: "blockson",
        spaces: ["blockson"]
      },
      {
        slug: "charles",
        spaces: [
                  "charles",
                  "service_zone",
                  "scrc",
                  "scholars_studio",
                  "asrs",
                  "guest_computers",
                  "cafe",
                  "24-7"
                ]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg", "innovation"]
      },
      {
        slug: "podiatry",
        spaces: ["podiatry"]
      }
    ]

    it "correctly names locations from sync" do
      expect { get hours_path.to have_text(/Special Collections Research Center/) }
      expect { get hours_path.to have_text(/Online/) }
    end
  end

end
