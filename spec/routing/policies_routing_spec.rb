# frozen_string_literal: true

require "rails_helper"

RSpec.describe PoliciesController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/policies/1").to route_to("policies#show", id: "1")
    end
  end
end
