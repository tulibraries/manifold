# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe BlogSerializer do
  let(:blog) { FactoryBot.create(:blog_with_sync_date) }
  let(:serialized) { described_class.new(blog) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :blog
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:title, :base_url, :feed_path,
                                                :last_sync_date, :public_status, :label)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:title])
    end
  end

  describe "serialized_json" do
    it "returns valid json" do
      Tempfile.open(["serialized_blog", ".json"]) do |tempfile|
        tempfile.write(serialized.to_json)
        tempfile.close
        args = %W[validate -s app/schemas/blog_schema.json -d #{tempfile.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
