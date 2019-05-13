# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalLink, type: :model do
  context "Validations" do
    let(:external_link) { FactoryBot.build(:external_link) }
    context "check for presence" do
      required_fields = ["title", "link"]
      required_fields.each do |field|
        it "raises an error when #{field} is not present" do
          external_link.update_attribute(field, "")
          expect { external_link.save! }.to raise_error(/#{field.humanize(capitalize: true)} can't be blank/)
        end
      end
    end
    context "checks for a well formed url" do
      it "raises and error when an invalid url is submitted" do
        expect { FactoryBot.create(:external_link_bad_url) }.to raise_error(/#{I18n.t('manifold.error.invalid_url')}/)
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

  it_behaves_like "categorizable"
end
