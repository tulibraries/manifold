# frozen_string_literal: true

require "rails_helper"

RSpec.describe "events/show", type: :view do

  it "displays the sample event image" do
    @event = FactoryBot.create(:event, :with_image)
    render
    expect(rendered).to match /#{@event.image.attachment.blob.filename.to_s}/
  end

  it "displays the default event image when image from xml feed cannot be rendered" do
    @event = FactoryBot.create(:event)
    render
    expect(rendered).to match /#{"assets/T"}/
  end

  context "JSON LD" do
    example "Location is campus building" do
      building = FactoryBot.create(:building)
      @event = FactoryBot.create(:event, building: building)
      render
      event_ld = JSON.parse(Nokogiri::XML(rendered).xpath("//script", "@type" => "Event").text)
      expect(event_ld["name"]).to match(@event.title)
      expect(event_ld["description"]).to match(@event.description.body.to_html)
    end
  end
end
