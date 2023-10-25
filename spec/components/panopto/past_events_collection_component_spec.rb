# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::PastEventsCollectionComponent, type: :component do
  before(:all) do
    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
    end
  end

  let(:videos) { Panopto::VideoDistributor.call(type: "collection", collection: "beyond-the-page") }

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
