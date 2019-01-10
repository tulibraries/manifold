# frozen_string_literal: true

require "rails_helper"

RSpec.describe "groups/show.html.erb", type: :view do
  before(:all) do
    @person = FactoryBot.create(:person)
    @group = FactoryBot.create(:group, persons: [@person])
  end
  it "displays the sample group name" do
    render
    expect(rendered).to match /#{@group.name}/
  end

  it "displays the person" do
    render
    expect(rendered).to match /#{@person.last_name}/
  end

  it "displays the space" do
    render
    expect(rendered).to match /#{@group.space.name}/
  end
end
