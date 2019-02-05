# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/finding_aids/1").to route_to("finding_aids#show", id: "1")
    end

  end
end
