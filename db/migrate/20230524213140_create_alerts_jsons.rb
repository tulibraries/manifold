# frozen_string_literal: true

class CreateAlertsJsons < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts_jsons do |t|
      t.text :message

      t.timestamps
    end

    # Create the alerts.json record
    AlertsJson.create(message: "")
  end
end
