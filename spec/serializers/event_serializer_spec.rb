# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe EventSerializer do
  let(:event) { FactoryBot.create(:event, :with_image) }
  let(:serialized) { described_class.new(event) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :event
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:title, :start_time, :end_time, :cancelled,
                                                :registration_status, :registration_link, :content_hash,
                                                :alt_text, :ensemble_identifier, :tags, :all_day,
                                                :space, :address1, :address2, :contact_name,
                                                :contact_email, :contact_phone, :image, :thumbnail_image,
                                                :label, :updated_at)
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(controller: "events", action: :show, id: event.to_param)
    end

    describe "event with image" do
      let (:event) { FactoryBot.create(:event, :with_image) }

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
        it "returns the title" do
          label = data[:attributes][:label]
          expect(label).to match(data[:attributes][:title])
        end
      end
    end
  end

  it_behaves_like "serializer"

end
