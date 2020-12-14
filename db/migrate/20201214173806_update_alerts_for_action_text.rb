# frozen_string_literal: true

class UpdateAlertsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    rename_column :alerts, :description, :description_old

    Alert.find_each do |alert|
      alert.update(description: alert.description_old)
    end

    remove_column :alerts, :description_old
  end

  def down
    add_column :alerts, :description_new, :text

    Alert.find_each do |alert|
      alert.update(description_new: alert.description.body.to_html) if alert.description.body.present?
    end

    rename_column :alerts, :description_new, :description
  end
end
