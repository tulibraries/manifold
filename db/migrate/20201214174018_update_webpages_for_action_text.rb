# frozen_string_literal: true

class UpdateWebpagesForActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper

  def up
    unless column_exists? :webpages, :description
      add_column :webpages, :description, :text
    end
    unless column_exists? :webpages, :covid_alert
      add_column :webpages, :covid_alert, :text
    end
    rename_column :webpages, :description, :description_old
    rename_column :webpages, :covid_alert, :covid_alert_old

    Webpage.find_each do |webpage|
      webpage.update(description: webpage.description_old)
      webpage.update(covid_alert: webpage.covid_alert_old)
    end

    remove_column :webpages, :description_old
    remove_column :webpages, :covid_alert_old
  end

  def down
    add_column :webpages, :description_new, :text
    add_column :webpages, :covid_alert_new, :text

    Webpage.find_each do |webpage|
      webpage.update(description_new: webpage.description.body.to_html) if webpage.description.body.present?
      webpage.update(covid_alert_new: webpage.covid_alert.body.to_html) if webpage.covid_alert.body.present?
    end

    rename_column :webpages, :description_new, :description
    rename_column :webpages, :covid_alert_new, :covid_alert
  end
end
