# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/show", type: :view do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }


  it "displays the sample person image" do
    @person = FactoryBot.create(:person, :with_image, spaces: [space])
    @buildings = [building]
    render
    expect(rendered).to match /#{@person.image.attachment.blob.filename.to_s}/
  end

  xit "displays the default image when no custom image supplied" do
    @person =  FactoryBot.create(:person, spaces: [space])
    @buildings = [building]
    render
    expect(rendered).to match /#{"assets/T-borderless"}/
  end
end
