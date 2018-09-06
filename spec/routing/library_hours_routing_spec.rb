require "rails_helper"

RSpec.describe LibraryHoursController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/library_hours").to route_to("library_hours#index")
    end

    it "routes to #new" do
      expect(:get => "/library_hours/new").to route_to("library_hours#new")
    end

    it "routes to #show" do
      expect(:get => "/library_hours/1").to route_to("library_hours#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/library_hours/1/edit").to route_to("library_hours#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/library_hours").to route_to("library_hours#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/library_hours/1").to route_to("library_hours#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/library_hours/1").to route_to("library_hours#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/library_hours/1").to route_to("library_hours#destroy", :id => "1")
    end

  end
end
