require 'rails_helper'

RSpec.describe "spaces/show.html.erb", type: :view do
  it "displays the sample space name" do
    @space = FactoryBot.build(:space)
    render
    expect(rendered).to match /#{@space.name}/
  end
end
