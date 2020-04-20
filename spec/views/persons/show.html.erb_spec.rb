# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/show", type: :view do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }

  before(:each) do
    @buildings = [building]
    @person =  FactoryBot.create(:person, libguides_account: "", springshare_id: "", spaces: [space])
  end

  it "displays the sample person image" do
    @person = FactoryBot.create(:person, :with_image, spaces: [space])
    render
    expect(rendered).to match /#{@person.image.attachment.blob.filename.to_s}/
  end

  it "displays the default image when no custom image supplied" do
    render
    expect(rendered).to match /#{"assets/T-"}/
  end

  it "returns a formatted springshare link if springshare_id field populated" do
    @person = FactoryBot.create(:person, spaces: [space])
    render
    expect(rendered).to match(@person.springshare_id)
  end

  it "does not return a formatted springshare link if springshare_id field populated" do
    render
    expect(rendered).to match(@person.springshare_id)
  end

  it "returns a formatted springshare link if springshare_id field populated" do
    @person = FactoryBot.create(:person, spaces: [space])
    render
    expect(rendered).to match(@person.libguides_account)
  end

  it "does not return a formatted springshare link if springshare_id field populated" do
    render
    expect(rendered).to match(@person.libguides_account)
  end

end
