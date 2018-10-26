# frozen_string_literal: true

require "rails_helper"

RSpec.describe "groups/index.html.erb", type: :view do
  it "displays the group template" do
    @groups = [ ]
    render
    expect(rendered).to match /Groups/
  end

  # it "displays the sample group name" do
  #   @groups = [ FactoryBot.build(:group) ]
  #   render
  #   expect(rendered).to match /#{@groups.first.name}/
  # end
end
