# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalLink, type: :model do
  context "Validations" do
    let(:external_link) { FactoryBot.build(:external_link) }
    context "check for presence" do
      required_fields = ["title", "link"]
      required_fields.each do |field|
        it "raises an error when #{field} is not present" do
          external_link.update(field => "")
          expect { external_link.save! }.to raise_error(/#{field.humanize(capitalize: true)} can't be blank/)
        end
      end
    end
  end

  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      link: ["https://example.com/original.html", "https://example.com/modified.html"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        external_link = FactoryBot.create(:external_link, k => v.first)
        external_link.update(k => v.last)
        external_link.save!
        expect(external_link.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "#link_cleanup!" do
    context "the value to be saved starts with a '/'" do
      it "doesn't add an extra '/' before saving" do
        el = ExternalLink.create!(title: "Explore Charles", link: "/explore-charles")
        expect(el.link).to eq "/explore-charles"
      end
    end

    context "the value to be saved does not start with a '/'" do
      it "adds a starting '/' before saving" do
        el = ExternalLink.create!(title: "Explore Charles", link: "explore-charles")
        expect(el.link).to eq "/explore-charles"
      end
    end

    context "the value is a URL" do
      it "returns the original url" do
        url = "https://librarysearch.temple.edu/srcr"
        el = ExternalLink.create!(title: "Explore Charles", link: url)
        expect(el.link).to eq url
      end
    end

    context "when link is attached to other models" do
      let(:external_link) { FactoryBot.build(:external_link) }
      let(:webpage) { FactoryBot.create(:webpage, external_link:) }
      it "is prevented from destruction" do
        external_link.delete
        expect(external_link).to be
      end
    end
  end

  it_behaves_like "categorizable"
end
