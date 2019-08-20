# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsController, type: :routing do
  describe "standard routing" do
    it "routes to #show" do
      expect(get: "/finding_aids/1").to route_to("finding_aids#show", id: "1")
    end
  end
  describe "redirect routing" do
    before { FactoryBot.create(:finding_aid) }
    context "legacy scrc search path" do
      it "does not get routed to the finding aid controller" do
        expect(get: "/scrc/search")
          .not_to route_to("finding_aids#show", path: "search")
      end
    end
  end

end
