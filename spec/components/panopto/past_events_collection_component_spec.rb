# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsCollectionComponent, type: :component do

  let(:videos) {
    VCR.use_cassette("video-collection") do
      Panopto::VideoDistributor.call(type: "collection", collection: "beyond-the-page")
    end
  }

  describe "loads videos" do
    it "takes data successfully" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(videos:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to be
    end
    it "takes data successfully" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(videos:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to match("Beyond the Page")
    end
  end

end
