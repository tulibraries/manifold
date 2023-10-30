# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsVideoComponent, type: :component do

  let(:videos) {
    VCR.use_cassette("video-all") do
      Panopto::VideoDistributor.call(type: "all")
    end
  }
  let(:video_stub) {
    videos[:recent][:videos].first
  }
  let(:video) {
    VCR.use_cassette("video-show") do
      Panopto::VideoDistributor.call(type: "show", video_id: video_stub[:Id])
    end
  }
  let(:missing_video) {
    VCR.use_cassette("video-show") do
      Panopto::VideoDistributor.call(type: "show", video_id: 7)
    end
  }

  describe "loads videos" do

    it "takes data successfully" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(video:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to be
    end

    it "takes data successfully" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(video:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to match(video[:Name].to_s)
    end
  end

end
