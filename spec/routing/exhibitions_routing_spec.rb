# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExhibitionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exhibitions").to route_to("exhibitions#index")
    end

    it "routes to #new" do
      expect(get: "/exhibitions/new").to route_to("exhibitions#new")
    end

    it "routes to #show" do
      expect(get: "/exhibitions/1").to route_to("exhibitions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/exhibitions/1/edit").to route_to("exhibitions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/exhibitions").to route_to("exhibitions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exhibitions/1").to route_to("exhibitions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exhibitions/1").to route_to("exhibitions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exhibitions/1").to route_to("exhibitions#destroy", id: "1")
    end
  end
end
