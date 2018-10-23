# frozen_string_literal: true

require "rails_helper"

RSpec.describe HighlightsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/highlights/1").to route_to("highlights#show", id: "1")
    end

  end
end
