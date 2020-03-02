# frozen_string_literal: true

require "rails_helper"

RSpec.describe "exhibitions/show", type: :view do
  it "renders attributes in <p>" do
    @exhibition = FactoryBot.create(:exhibition, :with_image, title: "Salvador Dali", description: "Spontaneous", start_date: Date.new)
    render
    expect(rendered).to match(/Salvador Dali/)
    expect(rendered).to match(/Spontaneous/)
  end
end
