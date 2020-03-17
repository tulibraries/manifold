# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "attachable" do

  let(:model) { described_class } # the class that includes the concern

  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }
  let(:factory_model2) { FactoryBot.create(model.to_s.underscore.to_sym) } # 2nd instance of the class that includes the concern
  let(:file1) { FactoryBot.create(:file_upload) }
  let(:file2) { FactoryBot.create(:file_upload) }
  let(:single_file) {
    factory_model.file_uploads << file1
    factory_model
  }
  let(:multiple_files) {
    factory_model.file_uploads << file1
    factory_model.file_uploads << file2
    factory_model
  }

  it "has an upload method" do
    expect(factory_model).to respond_to(:file_uploads)
  end

  it "can have one faile attached to it" do
    expect { single_file }.not_to raise_error
  end

  it "can have multiple files attached to it" do
    expect { multiple_files }.not_to raise_error
  end

  context "when it has no files" do
    it "the upload method returns an empty object" do
      expect(factory_model.file_uploads).to be_empty
    end
  end

  context "when it has one accounts" do
    it "the accounts method returns an array with the expected account" do
      expect(single_file.file_uploads).to include(file1)
    end
  end

  context "when it has multiple accounts" do
    it "the accounts method returns an array with the expected accounts" do
      expect(multiple_files.file_uploads).to include(file1, file1)
    end
  end

  context "when a file_upload is deleted" do
    it "removes that file from an item's file_uploads" do
      factory_model.file_uploads << file1
      file1.destroy
      factory_model.reload
      expect(factory_model.file_uploads).to match_array([])
    end
  end

  context "when a file_upload attached to one resource is also added to another resource" do
    it "keeps both file_uploads attached respectively" do
      factory_model.file_uploads << file1
      factory_model2.file_uploads << file1
      factory_model.reload
      expect(factory_model.file_uploads).to contain_exactly(file1)
    end
  end

end
