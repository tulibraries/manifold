require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
#    @event = assign(:event, Event.create!(
#      :title => "Title",
#      :description => "MyText",
#      :building => nil,
#      :space => nil,
#      :start_time => "2018-09-24 11:32:13",
#      :end_time => "2018-09-24 11:32:13",
#      :external_building => "External Building",
#      :external_space => "External Space",
#      :external_address => "External Address",
#      :external_city => "External City",
#      :external_state => "External State",
#      :external_zip => "External Zip",
#      :person => nil,
#      :external_contact_name => "External Contact Name",
#      :external_contact_email => "External Contact Email",
#      :external_contact_phone => "External Contact Phone",
#      :cancelled => false,
#      :registration_status => false,
#      :registration_link => "Registration Link",
#      :content_hash => "Content Hash"
#    ))
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

  before(:each) do
    @event = FactoryBot.build(:event, building: building, space: space, person: person)
    assign(:events, [@event])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@event.title}/)
    expect(rendered).to match(/#{@event.description}/)
    expect(rendered).to match(/#{@event.start_time}/)
    expect(rendered).to match(/#{@event.end_time}/)
    expect(rendered).to match(/#{building.name}/)
    expect(rendered).to match(/#{space.name}/)
    expect(rendered).to match(/#{@event.external_building}/)
    expect(rendered).to match(/#{@event.external_space}/)
    expect(rendered).to match(/#{@event.external_address}/)
    expect(rendered).to match(/#{@event.external_city}/)
    expect(rendered).to match(/#{@event.external_state}/)
    expect(rendered).to match(/#{@event.external_zip}/)
    expect(rendered).to match(/#{person.first_name}/)
    expect(rendered).to match(/#{person.last_name}/)
    expect(rendered).to match(/#{@event.external_contact_name}/)
    expect(rendered).to match(/#{@event.external_contact_email}/)
    expect(rendered).to match(/#{@event.external_contact_phone}/)
    expect(rendered).to match(/#{@event.cancelled}/)
    expect(rendered).to match(/#{@event.registration_status}/)
    expect(rendered).to match(/#{@event.registration_link}/)
    expect(rendered).to match(/#{@event.content_hash}/)
  end
end
