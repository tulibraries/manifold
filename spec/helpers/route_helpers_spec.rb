# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Custom Route Helpers", type: :helper do


  let(:category) { FactoryBot.create(:category, name: "policy") }
  let(:policy) { FactoryBot.create(:policy) }

  before(:each) do
    policy.categories << category
  end

  describe "category_url" do
    context "without a custom url" do
      it "routes to first item" do
        expect(category_url(category)).to match(/^http:\/\/test.host\/policies\/#{policy.id}/)
      end
    end

    context "with a custom_url" do
      let(:category) { FactoryBot.create(:category, :custom_url) }
      it "routes to external url" do
        expect(category_url(category)).to match(/http:\/\/sand.man/)
      end
    end

    context "when no items are in the category" do
      before do
        policy.categories.each(&:destroy)
      end

      it "routes to the root url" do
        expect(category_path(category)).to match(/^http:\/\/test.host\//)
      end
    end
  end

  describe "category_path" do
    context "without a custom_url" do
      it "returns the path to the first item in the category" do
        expect(category_path(category)).to match(/^\/policies\/#{policy.id}/)
      end
    end

    context "with a custom_url" do
      let(:category) { FactoryBot.create(:category, :custom_url) }
      it "routes to external url" do
        expect(category_path(category)).to match(/http:\/\/sand.man/)
      end
    end

    context "when no items are in the category" do
      before do
        policy.categories.each(&:destroy)
      end

      it "routes to the root url" do
        expect(category_path(category)).to match(/\//)
      end
    end
  end
end
