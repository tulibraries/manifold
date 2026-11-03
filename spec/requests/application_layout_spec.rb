# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Application layout", type: :request do
  describe "on a non-error page" do
    # Any page using the application layout works; a building page is cheap to
    # render (the factory has no hours, so no Google Sheets call).
    let(:building) { FactoryBot.create(:building) }

    it "loads the CookieChimp widget" do
      get building_path(building)
      expect(response.body).to include("cookiechimp.com/widget")
    end
  end
end
