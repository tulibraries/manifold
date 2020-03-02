# frozen_string_literal: true

require "rails_helper"

RSpec.describe "collections/show.html.erb", type: :view do
  before(:all) do
    @colletion = FactoryBot.create(:colletion, :with_image)
  end

  it "displays the sample colletion image" do
    view.lookup_context.prefixes << 'application'
    render
    expect(rendered).to match /#{@colletion.image}/
  end

end
