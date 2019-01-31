# frozen_string_literal: true

require "rails_helper"

RSpec.describe "events/show", type: :view do
  context "JSON LD" do
    example "Location is campus building" do
      building = FactoryBot.create(:building)
      @event = FactoryBot.create(:event, building: building)
      render
      event_ld = JSON.parse(Nokogiri::XML(rendered).xpath("//script", "@type" => "Event").text)
      expect(event_ld["name"]).to match(@event.title)
      expect(event_ld["description"]).to match(@event.description)
    end
  end
end
