# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/index", type: :view do

  it "displays the specialist print link" do
    @person = FactoryBot.create(:person, :with_image)
    allow(view).to receive(:params).and_return({ specialists: "true" })
    render
    expect(rendered).to match /id="specialist-print"/
  end

end
