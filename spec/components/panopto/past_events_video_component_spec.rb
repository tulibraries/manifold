# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsVideoComponent, type: :component do
  before(:all) do
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end
  end

  let(:videos) { Panopto::VideoDistributor.call(type: "all") }
  let(:video_stub) { videos[:recent][:videos].first }
  let(:video) { Panopto::VideoDistributor.call(type: "show", video_id: video_stub[:Id]) }
  let(:missing_video) { Panopto::VideoDistributor.call(type: "show", video_id: 7) }

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
      ).to match(video[:Name])
    end
  end

end
