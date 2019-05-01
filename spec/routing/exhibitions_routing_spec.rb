# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExhibitionsController, type: :routing do
  it_behaves_like "routes_for_imageable"

  describe "routing" do
    it "routes to #index" do
      expect(get: "/exhibitions").to route_to("exhibitions#index")
    end

    it "routes to #show" do
      expect(get: "/exhibitions/1").to route_to("exhibitions#show", id: "1")
    end
  end
end
