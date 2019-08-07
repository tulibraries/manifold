# frozen_string_literal: true

require "rails_helper"

RSpec.describe Redirect, type: :model do

  describe "#path" do
    context "a static link" do
      let(:redirect) { FactoryBot.create(:static_redirect) }

      it "returns the expected path" do
        expect(redirect.path).to eq "/hours"
      end

    end

    context "a entity link" do
      let(:redirect) { FactoryBot.create(:entity_redirect) }

      it "returns the redirectable object" do
        expect(redirect.path).to eq redirect.redirectable
      end
    end
  end

  describe "#strip_starting_slash_in_legacy_path" do
    context "the value to be saved starts with a '/'" do
      it "strips out the starting '/' before saving" do
        r = Redirect.create!(legacy_path: "/scrc")
        expect(r.legacy_path).to eq "scrc"
      end
    end

    context "the value to be saved contains a '/', but not at the start" do
      it "does not strip out the middling '/' before saving" do
        r = Redirect.create!(legacy_path: "pages/scrc")
        expect(r.legacy_path).to eq "pages/scrc"
      end
    end
  end

  describe "#ensure_starting_slash_in_manifold_path" do
    context "the value to be saved starts with a '/'" do
      it "doesn't add an extra '/' before saving" do
        r = Redirect.create!(manifold_path: "/scrc")
        expect(r.manifold_path).to eq "/scrc"
      end
    end

    context "the value to be saved does not start with a '/'" do
      it "adds a starting '/' before saving" do
        r = Redirect.create!(manifold_path: "forms/ask-scrc")
        expect(r.manifold_path).to eq "/forms/ask-scrc"
      end
    end
  end

end
