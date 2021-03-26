# frozen_string_literal: true

class UpdateServicesForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    change_table :services, bulk: true do |t|
      rename_column :services, :description, :description_old
      rename_column :services, :access_description, :access_description_old
      rename_column :services, :covid_alert, :covid_alert_old

      Service.find_each do |service|
        service.update(description: service.description_old)
        service.update(access_description: service.access_description_old)
        service.update(covid_alert: service.covid_alert_old)
      end

      remove_column :services, :description_old
      remove_column :services, :access_description_old
      remove_column :services, :covid_alert_old
    end
  end

  def down
    change_table :services, bulk: true do |t|
      add_column :services, :description_new, :text
      add_column :services, :access_description_new, :text
      add_column :services, :covid_alert_new, :text

      Service.find_each do |service|
        service.update(description_new: service.description.body.to_html) if service.description.body.present?
        service.update(access_description_new: service.access_description.body.to_html) if service.access_description.body.present?
        service.update(covid_alert_new: service.covid_alert.body.to_html) if service.covid_alert.body.present?
      end

      rename_column :services, :description_new, :description
      rename_column :services, :access_description_new, :access_description
      rename_column :services, :covid_alert_new, :covid_alert
    end
  end
end
