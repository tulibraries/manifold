# frozen_string_literal: true

require "rails_helper"


RSpec.describe "AWS credentials initializer" do

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
