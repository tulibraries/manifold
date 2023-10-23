# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsSearchComponent, type: :component do
  before(:all) do
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end
  end

  let!(:videos) { Panopto::VideoDistributor.call(type: "search", query: "livingstone") }

  describe "loads videos" do

    it "takes data successfully" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(videos:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil))
      ).to be
    end
    it "returns results" do
      expect(videos.size > 0).to be_truthy
    end
    it "takes returns relevant results" do
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      component = described_class.new(videos:)
      expect(
        component.render_in(ActionView::Base.new(ActionView::LookupContext.new([]), {}, videos))
      ).to match("livingstone")
    end
  end

end
