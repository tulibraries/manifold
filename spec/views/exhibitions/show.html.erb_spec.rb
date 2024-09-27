# frozen_string_literal: true

require "rails_helper"

RSpec.describe "exhibitions/show", type: :view do

  it "renders attributes in <p>" do
    @exhibition = FactoryBot.create(:exhibition)
    render
    expect(rendered).to match(/Salvador Dali/)
    expect(rendered).to match(/Hello World/)
  end

  it "renders the sample image" do
    @exhibition = FactoryBot.create(:exhibition, :with_image)
    render
    expect(rendered).to match /#{@exhibition.images.first.blob.filename}/
  end

  xit "renders script for exhibition" do
    @exhibition = FactoryBot.create(:exhibition, online_url: "https://library.temple.edu")
    render
    binding.pry
    exhibition_ld = JSON.parse(Nokogiri::XML(rendered).xpath("//script").text)
    expect(exhibition_ld["name"]).to match("Online")
  end

  it "displays online info" do
    @exhibition = FactoryBot.create(:exhibition, online_url: "https://library.temple.edu")
    render
    expect(rendered).to match /#{@exhibition.online_url}/
  end
end
