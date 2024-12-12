# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "imageables" do
  let(:model) { described_class } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:plus_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:images) {
    file_path = Rails.root.join("spec/fixtures/charles.jpg")
    file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
    factory_model.images.attach(file)
  }

  it "has images added to it" do
    expect { images }.not_to raise_error
  end

  context "when it has no image" do
    it "the images attachment returns nil" do
      expect(factory_model.images.first).to be_nil
    end
  end

  context "when image filesize > 10M" do
    file_path = Rails.root.join("spec/fixtures/toobig.jpg")
    file = Rack::Test::UploadedFile.new(file_path, "image/jpeg")
    it "raises error when filesize is too large" do
      plus_model.images.attach(file)
      expect(plus_model.errors.full_messages).to include(/is too large/)
    end
  end

  context "when image is invalid content type" do
    file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
    file = Rack::Test::UploadedFile.new(file_path, "application/pdf")
    it "raises error when file content type is invalid" do
      plus_model.images.attach(file)
      expect(plus_model.errors.full_messages).to include(/has an invalid content type/)
    end
  end
end
