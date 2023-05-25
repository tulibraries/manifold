# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlertsJson, type: :model do
  let (:message) { "Test Message" }

  example "Create an alert" do
    AlertsJson.first.update(message: "#{message}")
    expect(AlertsJson.first.message).to match(/#{message}/)
  end
end
