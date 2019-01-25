# frozen_string_literal: true

require "rails_helper"

RSpec.describe "exhibitions/index.html.erb", type: :view do
  it "displays the exhibition template" do
    @exhibitions = [ ]
    render
    expect(rendered).to match /Exhibitions/
  end

end
