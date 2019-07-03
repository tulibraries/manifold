# frozen_string_literal: true

require "spec_helper"

RSpec.describe "AWS credentials initializer" do

  before(:all) do
    ENV['S3_ACCESS_KEY_ID'] = "access_key_id"
    ENV['S3_SECRET_ACCESS_KEY'] = "secret_access_key"
    ENV['S3_REGION'] = "region"
    ENV['S3_BUCKET'] = "bucket"
    require "rails_helper"

  end

  context "when ENV vars are set" do

    it "sets the aws access key id config" do
      expect(Rails.configuration.aws[:access_key_id]).to eq "access_key_id"
    end

    it "sets the aws secret access key config" do
      expect(Rails.configuration.aws[:secret_access_key]).to eq "secret_access_key"
    end

    it "sets the aws region config" do
      expect(Rails.configuration.aws[:region]).to eq "region"
    end

    it "sets the aws s3 bucket config" do
      expect(Rails.configuration.aws[:bucket]).to eq "bucket"
    end


  end

end
