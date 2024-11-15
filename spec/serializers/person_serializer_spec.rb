# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe PersonSerializer do
  let(:person) { FactoryBot.create(:person) }
  let(:serialized) { described_class.new(person) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :person
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :first_name, :last_name, :job_title, :email_address, :phone_number,
                                                :label, :updated_at)
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(controller: "persons", action: :show, id: person.to_param)
    end

    describe "person with image" do
      let (:person) { FactoryBot.create(:person, :with_image) }

      it "has the image and thumbnail attributes" do
        expect(data[:attributes].keys).to include(:image, :thumbnail_image)
      end

      describe "image attribute" do
        it "returns an valid url" do
          image_url = URI.parse(data[:attributes][:image])
          expect(image_url.kind_of? URI::HTTP).to be_truthy
        end
      end

      describe "thumbnail_image attribute" do
        it "returns an valid url" do
          image_url = URI.parse(data[:attributes][:thumbnail_image])
          expect(image_url.kind_of? URI::HTTP).to be_truthy
        end
      end

      describe "label attribute" do
        it "returns the name" do
          label = data[:attributes][:label]
          expect(label).to match(data[:attributes][:name])
        end
      end
    end
  end

  it_behaves_like "serializer"

end
