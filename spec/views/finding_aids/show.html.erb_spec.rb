# frozen_string_literal: true

require "rails_helper"

RSpec.describe "finding_aids/show", type: :view do
  before(:all) do
    @collection = FactoryBot.create(:collection)
  end
  it "renders attributes" do
    @finding_aid = FactoryBot.create(:finding_aid, collections: [@collection])
    render
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Identifier/)
  end
end
