# frozen_string_literal: true

require "rails_helper"

RSpec.describe "LibraryHours", type: :request do

  describe "/hours" do
    let(:hour) { FactoryBot.create(:library_hour) }
    let(:hour1) { FactoryBot.create(:library_hour, location_id: "online") }
    let(:hour2) { FactoryBot.create(:library_hour, location_id: "drop_in") }

    it "correctly names locations fron sync" do
      binding.pry
      expect { get hours_path.to have_text(/Drop-in Research Help/) }
      expect { get hours_path.to have_text(/Online/) }
    end
  end

end
