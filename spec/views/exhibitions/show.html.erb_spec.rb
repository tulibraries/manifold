# frozen_string_literal: true

require "rails_helper"

RSpec.describe "exhibitions/show", type: :view do

  it "renders attributes in <p>" do
    @exhibition = FactoryBot.create(:exhibition)
    render
    expect(rendered).to match(/Salvador Dali/)
    skip "rich text field not accessible as attribute"
    expect(rendered).to match(/Hello World/)
  end

  it "renders the sample image" do
    @exhibition = FactoryBot.create(:exhibition, :with_image)
    render
    expect(rendered).to match /#{@exhibition.images.first.blob.filename}/
  end
end
