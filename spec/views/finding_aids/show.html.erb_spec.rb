# frozen_string_literal: true

require "rails_helper"

RSpec.describe "finding_aids/show", type: :view do
  before(:each) do
    @collection = FactoryBot.create(:collection)
    @finding_aid = assign(:finding_aid, FindingAid.create!(
                                          name: "Name",
                                          description: "MyText",
                                          subject: "Subject",
                                          content_link: "Content Link",
                                          identifier: "Identifier",
                                          collection: @collection
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Content Link/)
    expect(rendered).to match(/Identifier/)
  end
end
