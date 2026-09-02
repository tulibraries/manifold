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
    @exhibition = FactoryBot.create(:exhibition, :with_images)
    render
    expect(rendered).to match /#{@exhibition.images.first.blob.filename}/
  end

  it "renders the featured image with its alt text" do
    @exhibition = FactoryBot.create(:exhibition, :with_processed_image,
                                    alt_text: "Dali melting clocks")
    render

    expect(rendered).to have_css("div.exhibition-featured-image img")
    expect(rendered).to include('alt="Dali melting clocks"')
  end

  it "falls back to a title-based alt text on the featured image" do
    @exhibition = FactoryBot.create(:exhibition, :with_processed_image, alt_text: nil)
    render

    expect(rendered).to include('alt="Exhibition image for Salvador Dali"')
  end

  it "omits the featured image container when no image is attached" do
    @exhibition = FactoryBot.create(:exhibition)
    render

    expect(rendered).not_to have_css("div.exhibition-featured-image")
  end

  it "renders script for exhibition" do
    @exhibition = FactoryBot.create(:exhibition, online_url: "https://library.temple.edu")
    render
    exhibition_ld = JSON.parse(Nokogiri::XML(rendered).xpath("//script").text)
    expect(exhibition_ld["location"]["name"]).to match("Online")
  end

  it "displays online info" do
    @exhibition = FactoryBot.create(:exhibition, online_url: "https://library.temple.edu")
    render
    expect(rendered).to match /#{@exhibition.online_url}/
  end
end
