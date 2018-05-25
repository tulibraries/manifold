require 'rails_helper'

RSpec.describe "spaces/index.html.erb", type: :view do
  it "displays the space template" do
    @spaces = [ ]
    render
    expect(rendered).to match /Spaces/
  end

  it "displays the sample space name" do
    @spaces = [ FactoryBot.build(:space) ]
    render
    expect(rendered).to match /#{@spaces.first.name}/
  end
end
