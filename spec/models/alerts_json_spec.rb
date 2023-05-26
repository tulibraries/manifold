# frozen_string_literal: true

require "rails_helper"

RSpec.describe AlertsJson, type: :model do
  let (:message) { "Test Message" }
  let (:alert) { FactoryBot.create(:alerts_json) }

  example "Create an alert" do
    alert.update(message: "#{message}")
    expect(alert.message).to match(/#{message}/)
  end
end
