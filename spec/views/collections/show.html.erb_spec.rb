# frozen_string_literal: true

require "rails_helper"

RSpec.describe "collections/show.html.erb", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
    @collection = FactoryBot.create(:collection, :with_image)
  end

  it "displays the sample collection image" do
    render
    expect(rendered).to match /#{@collection.image.attachment.blob.filename.to_s}/
  end

end
