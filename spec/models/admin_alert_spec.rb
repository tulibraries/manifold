# frozen_string_literal: true

require "rails_helper"

RSpec.describe Alert, type: :model do

  before(:all) do
    Alert.delete_all
  end

  describe "Publish Alerts" do
    let(:alert) { FactoryBot.create(:alert) }

    it 'mocks File.open for write' do
      alert = FactoryBot.create(:alert)
      buffer = StringIO.new()

      Alert.publish_json(buffer)

      # reading the buffer and checking its content.
      expected_json = JSON.parse(alert.to_json)
      actual_json = JSON.parse(buffer.string)["data"].first["attributes"]
      expect(actual_json["scroll_text"]).to match(expected_json["scroll_text"])
      expect(actual_json["link"]).to match(expected_json["link"])
      expect(actual_json["published"]).to be
    end
  end
end
