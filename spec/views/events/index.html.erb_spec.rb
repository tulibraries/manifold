# frozen_string_literal: true

require "rails_helper"

RSpec.describe "events/index", type: :view do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

  before(:each) do
    assign(:events, [
      FactoryBot.create(:event, building: building, space: space, person: person),
      FactoryBot.create(:event, building: building, space: space, person: person)
    ])
  end

  it "renders a list of events" do
    render
    expect(rendered).to include(Event.first.title)
    expect(rendered).to include(Event.last.title)
  end
end
