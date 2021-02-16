# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Active Storage smoke test", type: :routing do

  describe "Make sure active Storage requests not borked by cacth all route" do
    it "routes to the active storage controller" do
      expect(get: "/rails/active_storage/blobs/3x4mp13/hal.png").to route_to(
        controller: "active_storage/blobs/redirect", action: "show", signed_id: "3x4mp13",
        filename: "hal", format: "png")
    end
  end
end
