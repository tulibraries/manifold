# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection, type: :model do
  describe "Required attributes" do
    let(:collection) { FactoryBot.create(:collection) }

    example "Missing name" do
      collection = FactoryBot.build(:collection, name: "")
      expect { collection.save! }.to raise_error(/Name can't be blank/)
    end

    example "Missing description" do
      collection = FactoryBot.build(:collection, description: "")
      expect { collection.save! }.to raise_error(/Description can't be blank/)
    end

    context "External Link" do
      let(:external_link) { FactoryBot.create(:external_link) }
      example "attach external link" do
        collection = FactoryBot.create(:collection, external_link: external_link)
        expect(collection.external_link.title).to match(/#{external_link.title}/)
        expect(collection.external_link.link).to match(/#{external_link.link}/)
      end

      example "no external" do
        collection = FactoryBot.create(:collection)
        expect { collection.save! }.to_not raise_error
      end
    end

  end

  describe "Space association" do
    example "Specify space in a collection" do
      space = FactoryBot.build(:space)
      collection = FactoryBot.create(:collection, space: space)
      expect(collection.space).to be(space)
    end
  end

  describe "version all fields" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: ["The Text 1", "The Text 2"],
      # Subject not testable in rspec in this context
      #subject: ["The Text 1", "The Text 2"],
      contents: ["The Text 1", "The Text 2"],
      add_to_footer: [false, true],
    }

    fields.each do |k, v|
      example "#{k} changes" do
        collection = FactoryBot.create(:collection, k => v.first)
        collection.update(k => v.last)
        collection.save!
        expect(collection.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "Makes Linked Data hash" do
    let(:city) { "Philadelphia" }
    let(:state) { "PA" }
    let(:zip_code) { "19122" }
    let(:building) { FactoryBot.create(:building, address2: "#{city}, #{state}, #{zip_code}") }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:collection) { FactoryBot.create(:collection, :with_image, space: space) }

    describe "Linked data hash" do
      subject { collection.to_ld }

      it { is_expected.to include("name" => collection[:name]) }
      it { is_expected.to include("description" => collection[:description]) }
      it { is_expected.to include("location") }

      describe "location" do
        subject { collection.to_ld["location"] }

        it { is_expected.to include("@type" => "Place") }
        it { is_expected.to include("address") }

        describe "address" do
          subject { collection.to_ld["location"]["address"] }

          it { is_expected.to include("@type" => "PostalAddress") }
          it { is_expected.to include("streetAddress" => building.address1) }
          it { is_expected.to include("addressLocality" => city) }
          it { is_expected.to include("addressRegion" => state) }
          it { is_expected.to include("postalCode" => zip_code) }
        end
      end

      it { is_expected.to include("telephone" => building[:phone_number]) }
      it { is_expected.to include("email" => building[:email]) }
      it { is_expected.to include("image" => Rails.application.routes.url_helpers.rails_representation_url(collection.show_image)) }
      it { is_expected.to include("containedInPlace" => building[:campus]) }
      it { is_expected.to include("geo" => building[:coordinates]) }
      it { is_expected.to include("googleId" => building[:google_id]) }
    end

  end
  it_behaves_like "categorizable"
  it_behaves_like "imageable"
end
