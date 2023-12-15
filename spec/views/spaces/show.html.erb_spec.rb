# frozen_string_literal: true

require "rails_helper"

RSpec.describe "spaces/show.html.erb", type: :view do

  let(:space) { FactoryBot.create(:space, :with_image) }

  before(:each) do
    view.lookup_context.prefixes << "application"
    assign(:space, space)
  end


  describe "page displays image" do
    it "uses the imageable concern" do
      render
      expect(rendered).to match(space.name)
    end
  end

end
