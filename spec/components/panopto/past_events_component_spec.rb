# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsComponent, type: :component do

  let(:videos) {
    VCR.use_cassette("videos-all") do
      Panopto::VideoDistributor.call(type: "all")
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
      ).to match("Recent Videos")
    end
  end

end
