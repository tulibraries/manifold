# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe BlogSerializer do
  let(:blog) { FactoryBot.create(:blog) }
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
                                                :last_sync_date, :public_status, :label,
                                                :updated_at)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:title])
    end
  end

  it_behaves_like "serializer"

end
