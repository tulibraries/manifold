# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorsController, type: :routing do


  describe "a record not found error" do
    it "routes to #not_found" do
      expect(get: "/404").to route_to("errors#not_found")
    end
  end

  describe "a internal server error" do
    # home page with expected entities not defined should error
    it "routes to #internal_server_error" do
      expect(get: "/500").to route_to("errors#internal_server_error")
    end
  end
end
