# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom Route Helpers", type: :helper do

  let(:link) { FactoryBot.create(:external_link) }
  let(:category) { FactoryBot.create(:category, name: "policy") }

  describe "external_link_url" do
    it "calls the external_link Model instance method #link" do
      expect(link).to receive(:link)
      external_link_url(link)
    end
  end
end
