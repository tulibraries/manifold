require 'rails_helper'

RSpec.describe "persons/index.html.erb", type: :view do
  it "displays the person template" do
    @persons = [ ]
    render
    expect(rendered).to match /Persons/
  end

  it "displays the sample person name" do
    @persons = [ FactoryBot.build(:person) ]
    render
    expect(rendered).to match /#{@persons.first.last_name}/
  end
end
