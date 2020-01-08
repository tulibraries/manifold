# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "imageable" do
  let(:model) { described_class } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:image) {
    file_path = Rails.root.join("spec/fixtures/charles.jpg")
    file = fixture_file_upload(file_path, "image/png")
    factory_model.image.attach(file)
  }

  it "has an image added to it" do
    expect { image }.not_to raise_error
  end

  context "when it has no image" do
    it "the image attachment returns nil when not assigned" do
      expect(factory_model.image.attachment).to be_nil
    end
  end

  context "image_path route helpers" do
    context "when an image is attached" do
      before { image }

      it "has a thumbnail path" do
        expect(factory_model.thumb_image_path).to include("#{factory_model.id}/image/thumbnail")
        expect(factory_model.thumb_image_path).to start_with("/")
      end

      it "has a thumbnail url" do
        expect(factory_model.thumb_image_url).to include("#{factory_model.id}/image/thumbnail")
        expect(factory_model.thumb_image_url).to start_with("http")
      end

      it "has a index path" do
        expect(factory_model.index_image_path).to include("#{factory_model.id}/image/medium")
        expect(factory_model.index_image_path).to start_with("/")
      end

      it "has a index url" do
        expect(factory_model.index_image_path).to include("#{factory_model.id}/image/medium")
        expect(factory_model.index_image_url).to start_with("http")
      end

      it "has a show path" do
        expect(factory_model.show_image_path).to include("#{factory_model.id}/image/large")
        expect(factory_model.show_image_path).to start_with("/")
      end

      it "has a show url" do
        expect(factory_model.show_image_path).to include("#{factory_model.id}/image/large")
        expect(factory_model.show_image_url).to include("http://")
      end
    end

    context "when an image is not attached" do
      it "does not raise an error" do
        expect { factory_model.thumb_image_url }.not_to raise_error
      end

      it "does not raise an error" do
        expect { factory_model.thumb_image_url }.not_to raise_error
      end

    end
  end
end
