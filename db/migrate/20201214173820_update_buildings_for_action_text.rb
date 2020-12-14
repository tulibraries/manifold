# frozen_string_literal: true

class UpdateBuildingsForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    rename_column :buildings, :description, :description_old
    rename_column :buildings, :covid_alert, :covid_alert_old

    Building.find_each do |building|
      building.update(description: building.description_old)
      building.update(covid_alert: building.covid_alert_old)
    end

    remove_column :buildings, :description_old
    remove_column :buildings, :covid_alert_old
  end

  def down
    add_column :buildings, :description_new, :text
    add_column :buildings, :covid_alert_new, :text

    Building.find_each do |building|
      building.update(description_new: building.description.body.to_html) if building.description.body.present?
      building.update(covid_alert_new: building.covid_alert.body.to_html) if building.covid_alert.body.present?
    end

    rename_column :buildings, :description_new, :description
    rename_column :buildings, :covid_alert_new, :covid_alert
  end
end
