# frozen_string_literal: true

require "rails_helper"

RSpec.describe "spaces/show", type: :view do

  it "displays the sample space image" do
    space = FactoryBot.create(:space, :with_image,  building: FactoryBot.create(:building))
    render
    expect(rendered).to match /#{@space.image.attachment.blob.filename.to_s}/
  end

end
