# frozen_string_literal: true

require "rails_helper"

RSpec.describe "groups/show.html.erb", type: :view do
  it "displays the sample group name" do
    @group = FactoryBot.create(:group)
    render
    expect(rendered).to match /#{@group.name}/
  end

  it "displays the person" do
    @group = FactoryBot.create(:group)
    render
    expect(rendered).to match /#{Person.first.last_name}/
  end

  it "displays the space" do
    @group = FactoryBot.create(:group)
    render
    expect(rendered).to match /#{@group.space.name}/
  end
end
