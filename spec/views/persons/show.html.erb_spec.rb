# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/show", type: :view do

  let(:building) { FactoryBot.create(:building) }

  before(:each) do
    @buildings = [building]
    @person =  FactoryBot.create(:person, libguides_account: "", springshare_id: "", buildings: [building])
  end

  it "displays the sample person image" do
    @person = FactoryBot.create(:person, :with_image, buildings: [building])
    render
    expect(rendered).to match /#{@person.image.attachment.blob.filename.to_s}/
  end

  it "displays the default image when no custom image supplied" do
    render
    expect(rendered).to match /#{"assets/T"}/
  end

  it "returns a Make an Appointment link if springshare_id field populated" do
    @person = FactoryBot.create(:person, buildings: [building])
    render
    expect(rendered).to match(@person.springshare_id)
  end

  it "does NOT return a Make an Appointment link if springshare_id field NOT populated" do
    render
    expect(rendered).not_to match /#{"springshare-account"}/
  end

  it "returns a libguides link if libguides_account field populated" do
    @person = FactoryBot.create(:person, buildings: [building])
    render
    expect(rendered).to match(@person.libguides_account)
  end

  it "does NOT return a libguides link if libguides_account field NOT populated" do
    render
    expect(rendered).not_to match /#{"libguides-link"}/
  end

end
