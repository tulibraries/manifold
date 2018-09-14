require "rails_helper"

RSpec.describe HighlightsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/highlights").to route_to("highlights#index")
    end

    it "routes to #new" do
      expect(:get => "/highlights/new").to route_to("highlights#new")
    end

    it "routes to #show" do
      expect(:get => "/highlights/1").to route_to("highlights#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/highlights/1/edit").to route_to("highlights#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/highlights").to route_to("highlights#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/highlights/1").to route_to("highlights#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/highlights/1").to route_to("highlights#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/highlights/1").to route_to("highlights#destroy", :id => "1")
    end

  end
end
