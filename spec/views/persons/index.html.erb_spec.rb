# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/index.html.erb", type: :view do
  it "displays the person template" do
    @persons = [ ]
    render partial: "persons/alphamenu"
    render
    expect(rendered).to match /persons/
  end

  it "displays the sample person name" do
    @persons = [ FactoryBot.build(:person) ]
    render partial: "persons/alphamenu"
    render
    expect(rendered).to match /#{@persons.first.last_name}/
  end
end
